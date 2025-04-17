//
//  TranscribeManager.swift
//  ConDemo
//

import Foundation
import AWSClientRuntime
import AWSS3
import AWSTranscribe
import ClientRuntime
import AVFoundation

class TranscribeManager {
    static let shared = TranscribeManager()
    
    private init() {}
    
    private let outputBucket = APIKey.bucketName
    private let region = "ap-northeast-2"
    private let lang = "ko-KR"
    private let sampleRate = 48000
    
    // 입력 파일 형식
    enum AudioFormat: String {
        case ogg, pcm, flac, mp3, m4a, wav
    }
    
    // 트랜스크립션 에러 타입
    enum TranscriptionError: Error {
        case readError
        case parseError
        case noTranscriptionResponse
        case transcriptionFailed(String)
    }
    
    // 앱에서 사용하기 위한 메서드
    func transcribeAudioFile(at fileURL: URL) async throws -> [MessageData] {
        // 파일 확장자로부터 포맷 결정
        let fileExtension = fileURL.pathExtension.lowercased()
        guard let format = AudioFormat(rawValue: fileExtension) else {
            throw TranscriptionError.readError
        }
        
        // 작업 이름 생성
        let jobName = "transcription-job-\(UUID().uuidString)"
        
        // AWS 자격 증명 설정
        setenv("AWS_ACCESS_KEY_ID", APIKey.accessKey, 1)
        setenv("AWS_SECRET_ACCESS_KEY", APIKey.secretKey, 1)
        
        // 1. 파일을 S3에 업로드
        let s3Url = try await uploadFileToS3(fileURL: fileURL)
        
        // 2. 트랜스크립션 작업 시작
        let messages = try await startTranscriptionJob(
            jobName: jobName,
            s3Url: s3Url,
            format: format
        )
        
        return messages
    }
    
    // S3에 파일 업로드
    private func uploadFileToS3(fileURL: URL) async throws -> String {
        // S3 클라이언트 설정
        let s3Config = try await AWSS3.S3Client.S3ClientConfiguration(region: region)
        let s3Client = AWSS3.S3Client(config: s3Config)
        
        // 로컬 파일 경로에서 파일명 추출
        let fileName = fileURL.lastPathComponent
        let s3Key = "input/\(fileName)"
        
        // 파일 데이터 읽기
        let fileData = try Data(contentsOf: fileURL)
        
        // S3에 파일 업로드
        let putObjectRequest = AWSS3.PutObjectInput(
            body: .data(fileData),
            bucket: outputBucket,
            key: s3Key
        )
        
        _ = try await s3Client.putObject(input: putObjectRequest)
        let s3Url = "s3://\(outputBucket)/\(s3Key)"
        print("S3 URL: \(s3Url)")
        
        return s3Url
    }
    
    // 트랜스크립션 작업 시작
    private func startTranscriptionJob(
        jobName: String,
        s3Url: String,
        format: AudioFormat
    ) async throws -> [MessageData] {
        // AWS Transcribe 클라이언트 설정
        let config = try await TranscribeClient.TranscribeClientConfiguration(region: region)
        let transcribeClient: TranscribeClient = .init(config: config)
        
        // 미디어 객체 생성
        let media = TranscribeClientTypes.Media(mediaFileUri: s3Url)
        
        // 작업 요청 설정
        let startJobRequest = StartTranscriptionJobInput(
            languageCode: TranscribeClientTypes.LanguageCode.koKr,
            media: media,
            mediaFormat: TranscribeClientTypes.MediaFormat(rawValue: format.rawValue),
            outputBucketName: outputBucket,
            settings: TranscribeClientTypes.Settings(
                maxSpeakerLabels: 2,    // 화자 인원 설정
                showSpeakerLabels: true
            ),
            transcriptionJobName: jobName
        )
        
        print("트랜스크립션 시작: \(jobName)")
        let response = try await transcribeClient.startTranscriptionJob(input: startJobRequest)
        
        if let job = response.transcriptionJob {
            print("트랜스크립션 작업이 생성되었습니다.")
            print("작업 상태: \(job.transcriptionJobStatus?.rawValue ?? "알 수 없음")")
            
            // 작업 상태 모니터링
            return try await monitorTranscriptionJob(
                transcribeClient: transcribeClient,
                jobName: jobName
            )
        } else {
            print("트랜스크립션 작업 응답이 없습니다.")
            throw TranscriptionError.noTranscriptionResponse
        }
    }
    
    // 트랜스크립션 작업 모니터링
    private func monitorTranscriptionJob(
        transcribeClient: TranscribeClient,
        jobName: String
    ) async throws -> [MessageData] {
        let getJobRequest = GetTranscriptionJobInput(transcriptionJobName: jobName)
        
        let checkInterval: TimeInterval = 5.0 // 5초마다 상태 체크
        let maxChecks = 60 // 최대 300초(5분) 리밋
        
        for _ in 1...maxChecks {
            do {
                let response = try await transcribeClient.getTranscriptionJob(input: getJobRequest)
                
                if let job = response.transcriptionJob,
                   let status = job.transcriptionJobStatus {
                    if status == .completed {
                        if let transcript = job.transcript,
                           let uri = transcript.transcriptFileUri {
                            // S3에서 결과 데이터를 가져와서 파싱
                            return try await getResults(uri: uri)
                        }
                    } else if status == .failed {
                        print("트랜스크립션 실패")
                        if let failureReason = job.failureReason {
                            print("실패 이유: \(failureReason)")
                            throw TranscriptionError.transcriptionFailed(failureReason)
                        }
                        throw TranscriptionError.transcriptionFailed("Unknown reason")
                    }
                }
                
                // 5초마다 대기
                try await Task.sleep(nanoseconds: UInt64(checkInterval * 1_000_000_000))
            } catch {
                print("작업 상태 확인 오류: \(error)")
                throw error
            }
        }
        
        print("최대 확인 시간이 초과되었습니다. 작업은 계속 진행 중일 수 있습니다.")
        throw TranscriptionError.transcriptionFailed("Timeout")
    }
    
    // S3 결과 가져오기
    private func getResults(uri: String) async throws -> [MessageData] {
        // AWS 키 설정
        setenv("AWS_ACCESS_KEY_ID", APIKey.accessKey, 1)
        setenv("AWS_SECRET_ACCESS_KEY", APIKey.secretKey, 1)
        
        // URI 분석
        let bucket: String
        let key: String
        
        if uri.hasPrefix("s3://") {
            let uriWithoutPrefix = uri.dropFirst(5) // "s3://" 제거
            guard let firstSlashIndex = uriWithoutPrefix.firstIndex(of: "/") else {
                throw NSError(domain: "S3URIError", code: 2,
                              userInfo: [NSLocalizedDescriptionKey: "URI 형식이 올바르지 않음"])
            }
            
            bucket = String(uriWithoutPrefix[..<firstSlashIndex])
            key = String(uriWithoutPrefix[firstSlashIndex...].dropFirst())
        } else if uri.hasPrefix("https://") && uri.contains("amazonaws.com") {
            // HTTPS URL 형식 처리
            guard let url = URL(string: uri) else {
                throw NSError(domain: "S3URIError", code: 4,
                              userInfo: [NSLocalizedDescriptionKey: "잘못된 HTTPS URL 형식"])
            }
            
            let pathComponents = url.pathComponents.filter { $0 != "/" }
            guard pathComponents.count >= 2 else {
                throw NSError(domain: "S3URIError", code: 5,
                              userInfo: [NSLocalizedDescriptionKey: "HTTPS URL 경로가 올바르지 않음"])
            }
            
            bucket = pathComponents[0]
            key = pathComponents.dropFirst().joined(separator: "/")
        } else {
            throw NSError(domain: "S3URIError", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "지원되지 않는 URI 형식입니다. s3:// 또는 https://s3.*.amazonaws.com 형식이어야 합니다."])
        }
        
        // AWS 클라이언트 설정
        let s3Config = try await AWSS3.S3Client.S3ClientConfiguration(region: region)
        let s3Client = AWSS3.S3Client(config: s3Config)
        
        // GetObject 요청 생성
        let getObjectRequest = AWSS3.GetObjectInput(bucket: bucket, key: key)
        
        // 요청 실행
        let response = try await s3Client.getObject(input: getObjectRequest)
        
        // 응답 데이터 처리
        if let data = try await response.body?.readData(),
           let content = String(data: Data(data), encoding: .utf8) {
            // 트랜스크립션 결과 파싱 및 처리
            do {
                let transcriptionResult = try parseTranscriptionContent(content)
                let messages = transcriptionResult.getTranscript()
                // 화자 분리된 스크립트 리턴
                return messages
            } catch {
                print("트랜스크립션 결과 파싱 중 오류 발생: \(error)")
                throw error
            }
        } else {
            throw NSError(domain: "S3URIError", code: 3,
                          userInfo: [NSLocalizedDescriptionKey: "데이터를 문자열로 변환할 수 없습니다."])
        }
    }
    
    // 결과 JSON 파싱
    private func parseTranscriptionContent(_ content: String) throws -> TranscriptionResponse {
        guard let jsonData = content.data(using: .utf8) else {
            throw TranscriptionError.parseError
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(TranscriptionResponse.self, from: jsonData)
        } catch {
            print("JSON 파싱 오류: \(error)")
            throw TranscriptionError.parseError
        }
    }
}
