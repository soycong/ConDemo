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

    // MARK: - Lifecycle

    init() {
        setupAudioSession()
    }
}

extension AudioRecorder {
    /// 녹음 시작
    func startRecording() {
        let fileURL = getSharedDocumentsDirectory()
            .appendingPathComponent("OurVoices-\(Date().timeIntervalSince1970).m4a")
        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 12000,
                        AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]

        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
        } catch {
            print("녹음 중 오류 발생: \(error)")
        }
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
    func stopRecording() {
        audioRecorder?.stop()
        recordedURLs.append(audioRecorder!.url)
        print("녹음 파일 위치: \(audioRecorder!.url)")
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
