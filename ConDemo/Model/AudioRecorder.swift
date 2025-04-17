//
//  AudioRecorder.swift
//  ConDemo
//
//  Created by 이명지 on 4/10/25.
//

import AVFoundation

final class AudioRecorder {
    // MARK: - Properties

    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordedURLs: [URL] = []
    
    private var recordingStartTime: Date?
    private var lastProcessedTime: TimeInterval = 0

    // MARK: - Lifecycle

    init() {
        setupAudioSession()
    }
}

extension AudioRecorder {
    /// 녹음 시작
func startRecording() {
        let fileURL = getSharedDocumentsDirectory()
            .appendingPathComponent("OurVoices-\(Date().timeIntervalSince1970).flac") // .flac로 변경
        
        // PCM 형식으로 설정 변경
//        let settings = [
//            AVFormatIDKey: Int(kAudioFormatLinearPCM),
//            AVSampleRateKey: 48000,  // AWS Transcribe와 동일한 샘플레이트 사용
//            AVNumberOfChannelsKey: 1,
//            AVLinearPCMBitDepthKey: 16,
//            AVLinearPCMIsFloatKey: false,
//            AVLinearPCMIsBigEndianKey: false,
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//        ] as [String : Any]
    
    // flac파일
    let settings = [
        AVFormatIDKey: Int(kAudioFormatFLAC),  // FLAC 형식으로 변경
        AVSampleRateKey: 48000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            recordingStartTime = Date() // 녹음 시작 시간 기록
            lastProcessedTime = 0 // 처리 시간 초기화
            audioRecorder?.record()
        } catch {
            print("녹음 중 오류 발생: \(error)")
        }
    }
    
    func getCurrentAudioSegment() -> String? {
        // 현재 녹음 중인 파일이 있는 경우 경로 반환
        guard let recorder = audioRecorder else {
            print("getCurrentAudioSegment: audioRecorder가 nil입니다")
            return nil
        }
        
        // 파일이 실제로 존재하는지 확인
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: recorder.url.path) {
            print("파일이 존재합니다: \(recorder.url.path)")
            
            // 파일 크기 확인
            do {
                let attributes = try fileManager.attributesOfItem(atPath: recorder.url.path)
                let fileSize = attributes[.size] as? UInt64 ?? 0
                print("파일 크기: \(fileSize) 바이트")
            } catch {
                print("파일 속성 확인 중 오류: \(error)")
            }
        } else {
            print("파일이 존재하지 않습니다: \(recorder.url.path)")
        }
        
        return recorder.url.path
    }
    
    // 마지막 처리 시간 업데이트
    func updateLastProcessedTime(time: TimeInterval) {
        lastProcessedTime = time
    }

    /// 녹음 일시정지
    func pauseRecording() {
        audioRecorder?.pause()
    }

    /// 녹음 재개
    func restartRecording() {
        audioRecorder?.record()
    }

    /// 녹음 중지
    func stopRecording() -> URL {
        audioRecorder?.stop()
        recordedURLs.append(audioRecorder!.url)
        return audioRecorder!.url
    }
}

extension AudioRecorder {
    private func setupAudioSession() {
        let audioSession: AVAudioSession = .sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("오디오 세션 설정 실패: \(error)")
        }
    }
    
    private func getSharedDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        let directoryPath = documentsDirectory.appendingPathComponent("Audio")
        
        // 폴더가 없으면 생성
        if !FileManager.default.fileExists(atPath: directoryPath.path) {
            do {
                try FileManager.default.createDirectory(at: directoryPath,
                                                        withIntermediateDirectories: true)
            } catch {
                print("디렉토리 생성 실패: \(error)")
            }
        }
        
        return directoryPath
    }
}
