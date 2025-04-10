//
//  AudioRecorder.swift
//  ConDemo
//
//  Created by 이명지 on 4/10/25.
//

import AVFoundation

final class AudioRecorder {
    // MARK: - Properties

    private var hasAudioSession: Bool?

    private var audioRecorder: AVAudioRecorder?
    private var isRecording = false
    private var isRecordingPaused = false

    private var audioPlayer: AVAudioPlayer?
    private var isPlaying = false
    private var isPlayingPaused = false

    private var recordedURLs: [URL] = []

    // MARK: - Lifecycle

    init() {
        setupAudioSession()
    }
}

extension AudioRecorder {
    /// 녹음 시작
    func startRecording() {
        let fileURL = getDocumentDirectory()
            .appendingPathComponent("OurVoices-\(Date().timeIntervalSince1970).m4a")
        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 12000,
                        AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]

        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("녹음 중 오류 발생: \(error)")
        }
    }

    /// 녹음 일시정지
    func pauseRecording() {
        guard isRecording else {
            return
        }

        audioRecorder?.pause()
        isRecordingPaused = true
    }

    /// 녹음 재개
    func restartRecording() {
        guard isRecording else {
            return
        }

        audioRecorder?.record()
        isRecordingPaused = false
    }

    /// 녹음 중지
    func stopRecording() {
        guard isRecording else {
            return
        }

        audioRecorder?.stop()
        recordedURLs.append(audioRecorder!.url)

        isRecording = false
        isRecordingPaused = false
    }
}

extension AudioRecorder {
    private func setupAudioSession() {
        let audioSession: AVAudioSession = .sharedInstance()

        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            hasAudioSession = true
        } catch {
            print("오디오 세션 설정 실패: \(error)")
            hasAudioSession = false
        }
    }

    private func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
