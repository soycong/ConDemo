//
//  RecordingMainViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/10/25.
//

final class RecordingMainViewModel {
    private(set) var isRecording = false

    private let audioRecorder: AudioRecorder = .init()

    private var isPlaying = false
    private var isPaused = false
}

extension RecordingMainViewModel {
    func startRecording() {
        audioRecorder.startRecording()
        isRecording = true
        print("녹음 시작")
    }

    func pauseRecording() {
        audioRecorder.pauseRecording()
        isRecording = false
        print("녹음 일시정지")
    }

    func restartRecording() {
        audioRecorder.restartRecording()
        isRecording = true
        print("녹음 재시작")
    }

    func stopRecording() {
        audioRecorder.stopRecording()
        isRecording = false
        print("녹음 종료")
    }

    func recordToggle() {
        // 녹음중이 아니다 -> 녹음 재시작
        if !isRecording {
            restartRecording()
        }
        // 녹음중이다 -> 녹음 일시정지
        else {
            pauseRecording()
        }
    }
}
