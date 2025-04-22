//
//  SpeechRecognizer.swift
//  ConDemo
//
//  Created by seohuibaek on 4/21/25.
//

import Speech

final class SpeechRecognizer: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private var isTranscribing = false
    weak var delegate: TranscriptionDelegate?
    
    // 문장 감지 관련 변수
    private var lastTranscriptLength = 0
    private var lastUpdateTime = Date()
    private var formattedTranscript = ""
    
    override init() {
        super.init()
        self.speechRecognizer.delegate = self
    }
    
    func startTranscribing() {
        // 기존 음성 인식중인지 판단
        guard !isTranscribing else { return }
        
        isTranscribing = true
        
        // 오디오 엔진이 실행 중이면 중지하고 모든 tap을 제거
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        // 기존 실행된 음성 인식 작업인, recognitionTask가 있다면 해당 작업 취소
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // 오디오 세션 설정 및 활성화
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("오디오 세션 설정 실패: \(error)")
            isTranscribing = false
            return
        }
        
        // 음성 인식 요청 생성
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            // 설정 중 오류 시 음성 인식 상태 변경
            isTranscribing = false
            return
        }
        
        // 부분적 결과 보고 설정
        recognitionRequest.shouldReportPartialResults = true
        
        
        if #available(iOS 16.0, *) {
            recognitionRequest.addsPunctuation = true // 구두점 추가 활성화
        }
        
        // . , ? , ! 일 때 문장 분리
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let strongSelf = self else { return }
            
            var isFinal = false
            
            if let result = result {
                let newTranscript = result.bestTranscription.formattedString
                DispatchQueue.main.async {
                    strongSelf.formatTranscriptWithLineBreaks(newTranscript)
                }
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                strongSelf.cleanup()
            }
        }
        
        // 오디오 엔진에 tap을 추가
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        // 오디오 엔진 시작
        do {
            try audioEngine.start()
        } catch {
            print("오디오 엔진 시작 실패: \(error)")
            cleanup()
        }
    }
    
    func stopTranscribing() {
        recognitionTask?.cancel()
        cleanup()
    }
    
    private func cleanup() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        // 변수 초기화
        lastTranscriptLength = 0
        lastUpdateTime = Date()
        formattedTranscript = ""
        
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask = nil
        isTranscribing = false // 인식 중 상태 해제
    }
}

extension SpeechRecognizer {
    private func formatTranscriptWithLineBreaks(_ newText: String) {
        let currentTime = Date()
        
        // ". ", "? ", "! " 를 기준으로 문장 포맷팅
        formattedTranscript = newText.replacingOccurrences(of: ". ", with: ".\n")
            .replacingOccurrences(of: "? ", with: "?\n")
            .replacingOccurrences(of: "! ", with: "!\n")
        
        lastTranscriptLength = newText.count
        lastUpdateTime = currentTime
        
        // 변환된 최종 텍스트를 델리게이트에 전달
        DispatchQueue.main.async {
            self.delegate?.didReceiveTranscription(text: self.formattedTranscript)
        }
    }
}
