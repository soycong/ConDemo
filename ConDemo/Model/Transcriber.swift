//
//  Transcriber.swift
//  ConDemo
//
//  Created by 이명지 on 4/15/25.
//

import ArgumentParser
import AWSClientRuntime
import AWSS3
import AWSTranscribe
import ClientRuntime
import Foundation

struct Transcriber: ParsableCommand {
    // MARK: - Nested Types

    /// input 파일 형식
    enum TranscribeFormat: String, ExpressibleByArgument {
        case ogg = "ogg"
        case pcm = "pcm"
        case flac = "flac"
        case mp3 = "mp3"
        case m4a = "m4a"
        case wav = "wav"
    }

    // MARK: - Static Properties

    static var configuration: CommandConfiguration = .init(commandName: "transcribe",
                                                           abstract: """
                                                           This example shows how to use Amazon Transcribe service.
                                                           """,
                                                           discussion: """
                                                           """)

    // MARK: - Properties

    @Option(help: "Language code to transcribe into")
    var lang: String = "ko-KR"
    @Option(help: "Format of the source audio file")
    var format: TranscribeFormat
    @Option(help: "Sample rate of the source audio file in Hertz")
    var sampleRate: Int = 48000
    @Option(help: "Path of the source audio file")
    var path: String
    @Option(help: "Name of the Amazon S3 Region to use(default: ap-northeast-2)")
    var region: String = "ap-northeast-2"
    @Option(help: "S3 bucket name for output")
    var outputBucket: String
    @Option(help: "Transcription job name")
    var jobName: String = "transcription-job-\(UUID().uuidString)"

    // MARK: - Functions

    func run() throws {
        let totalStartTime = CFAbsoluteTimeGetCurrent()

        // 환경 변수 설정
        setenv("AWS_ACCESS_KEY_ID", APIKey.accessKey, 1)
        setenv("AWS_SECRET_ACCESS_KEY", APIKey.secretKey, 1)

        Task {
            do {
                try await startTranscriptionJob()
            } catch {
                print("트랜스크립션 작업 실행 중 오류 발생: \(error)")
            }
        }

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 300))

        let totalEndTime = CFAbsoluteTimeGetCurrent()
        let executionTime = totalEndTime - totalStartTime

        print("\n**총 실행 시간: \(String(format: "%.2f", executionTime))초**")
    }

    func startTranscriptionJob() async throws {
        guard let bundleFileURL = Bundle.main.url(forResource: "testAudio", withExtension: "flac")
        else {
            print("프로젝트 내부에서 파일을 찾을 수 없습니다")
            throw TranscribeError.readError
        }

        // AWS 클라이언트 설정
        let config = try await TranscribeClient.TranscribeClientConfiguration(region: region)
        let transcribeClient: TranscribeClient = .init(config: config)

        // S3 클라이언트 설정
        let s3Config = try await AWSS3.S3Client.S3ClientConfiguration(region: region)
        let s3Client = AWSS3.S3Client(config: s3Config)

        // S3 URL 확인 및 생성
        let s3Url: String
        if path.hasPrefix("s3://") {
            s3Url = path
        } else {
            print("로컬 파일 S3 업로드")

            // 로컬 파일 경로에서 파일명 추출
            let fileName = bundleFileURL.lastPathComponent
            let s3Key = "input/\(fileName)"

            // 파일 데이터 읽기
//            let fileURL = URL(fileURLWithPath: path)
            let fileData = try Data(contentsOf: bundleFileURL)

            // S3에 파일 업로드
            let putObjectRequest = AWSS3.PutObjectInput(body: .data(fileData),
                                                        bucket: outputBucket,
                                                        key: s3Key)

            _ = try await s3Client.putObject(input: putObjectRequest)
            s3Url = "s3://\(outputBucket)/\(s3Key)"
            print("S3 URL: \(s3Url)")
        }

        // 미디어 객체 생성
        let media = TranscribeClientTypes.Media(mediaFileUri: s3Url)

        // TranscriptionJobRequest 설정
        let startJobRequest: StartTranscriptionJobInput = .init(languageCode: TranscribeClientTypes
            .LanguageCode.koKr,
            media: media,
            mediaFormat: TranscribeClientTypes
                .MediaFormat(rawValue: format
                    .rawValue),
            mediaSampleRateHertz: Int(sampleRate),
            outputBucketName: outputBucket,
            settings: TranscribeClientTypes
                .Settings(maxSpeakerLabels: 2,
                          showSpeakerLabels: true),
            transcriptionJobName: jobName)

        print("트랜스크립션 시작: \(jobName)")
        let response = try await transcribeClient.startTranscriptionJob(input: startJobRequest)

        if let job = response.transcriptionJob {
            print("트랜스크립션 작업이 생성되었습니다.")
            print("작업 상태: \(job.transcriptionJobStatus?.rawValue ?? "알 수 없음")")

            // 작업 상태 모니터링
            try await monitorTranscriptionJob(transcribeClient: transcribeClient)
        } else {
            print("트랜스크립션 작업 응답이 없습니다.")
            throw TranscribeError.noTranscriptionResponse
        }
    }

    func monitorTranscriptionJob(transcribeClient: TranscribeClient) async throws {
        let getJobRequest: GetTranscriptionJobInput = .init(transcriptionJobName: jobName)

        let checkInterval: TimeInterval = 5.0 // 5초마다 상태 체크
        let maxChecks = 60 // 최대 300초 리밋

        for _ in 1 ... maxChecks {
            do {
                let response = try await transcribeClient.getTranscriptionJob(input: getJobRequest)

                if let job = response.transcriptionJob,
                   let status = job.transcriptionJobStatus {
                    if status == .completed {
                        if let transcript = job.transcript,
                           let uri = transcript.transcriptFileUri {
                            // S3에서 결과 데이터를 가져와서 파싱
                            let jsonContent = try await readS3URI(uri: uri)
                        }
                        return
                    } else if status == .failed {
                        print("트랜스크립션 실패")
                        if let failureReason = job.failureReason {
                            print("실패 이유: \(failureReason)")
                        }
                        return
                    }
                }

                // 5초마다 대기
                try await Task.sleep(nanoseconds: UInt64(checkInterval * 1_000_000_000))
            } catch {
                print("작업 상태 확인 오류: \(error)")
                return
            }
        }

        print("최대 확인 시간이 초과되었습니다. 작업은 계속 진행 중일 수 있습니다.")
    }

    /// S3 URI 내용 출력
    func readS3URI(uri: String, region: String = "ap-northeast-2") async throws -> String {
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
            // HTTPS URL 형식 처리 (https://s3.region.amazonaws.com/bucket-name/path/to/file)
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
        let getObjectRequest = AWSS3.GetObjectInput(bucket: bucket,
                                                    key: key)

        // 요청 실행
        let response = try await s3Client.getObject(input: getObjectRequest)

        // 응답 데이터 처리
        if let data = try await response.body?.readData(),
           let content = String(data: Data(data), encoding: .utf8) {
            // 트랜스크립션 결과 파싱 및 처리
            do {
                let transcriptionResult = try parseTranscriptionContent(content)
                transcriptionResult.printTranscript()
                print()
                transcriptionResult.printSpeakersTranscript()
            } catch {
                print("트랜스크립션 결과 파싱 중 오류 발생: \(error)")
            }

            return content
        } else {
            throw NSError(domain: "S3URIError", code: 3,
                          userInfo: [NSLocalizedDescriptionKey: "데이터를 문자열로 변환할 수 없습니다."])
        }
    }
}

extension Transcriber {
    func parseTranscriptionContent(_ content: String) throws -> TranscriptionResult {
        guard let jsonData = content.data(using: .utf8) else {
            throw TranscribeError.parseError
        }

        let decoder: JSONDecoder = .init()
        do {
            return try decoder.decode(TranscriptionResult.self, from: jsonData)
        } catch {
            print("JSON 파싱 오류: \(error)")
            throw TranscribeError.parseError
        }
    }
}
