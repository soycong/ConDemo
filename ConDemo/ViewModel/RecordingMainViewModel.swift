//
//  RecordingMainViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/10/25.
//

final class RecordingMainViewModel {
    private let audioRecorder = AudioRecorder()
    private var isRecording = false
    private var isRecordingPaused = false
    
    private var isPlaying = false
    private var isPlayingPaused = false
    
}

extension RecordingMainViewModel {
    func startRecording() {
        audioRecorder.startRecording()
        
        self.isRecording = true
    }
    
    func pauseRecording() {
        guard isRecording else { return }
        
        audioRecorder.pauseRecording()
        self.isRecordingPaused = true
    }
    
    func restartRecording() {
        guard isRecording else { return }
        
        audioRecorder.restartRecording()
        self.isRecordingPaused = false
    }
    
    func stopRecording() {
        guard isRecording else { return }
        
        audioRecorder.stopRecording()
        self.isRecording = false
        self.isRecordingPaused = false
    }
}
