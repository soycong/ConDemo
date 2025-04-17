//
//  RecordingScriptViewModel.swift
//  ConDemo
//
//  Created by seohuibaek on 4/16/25.
//

import Foundation

final class RecordingScriptViewModel {
    // MARK: - Properties

    var onMessagesUpdated: (([MessageData]) -> Void)?
    var onError: ((Error) -> Void)?

    private var streamingTranscriber: StreamingTranscriber?

    private var messages: [MessageData] = [] {
        didSet {
            onMessagesUpdated?(messages)
        }
    }

    // MARK: - Functions
    
    func addMessage(_ messageData: MessageData) {
        messages.append(messageData)
    }

    func setupTranscriber() {
        do {
            streamingTranscriber = try StreamingTranscriber.parse(["--format", "flac",
                                                 "--path", "testAudio.flac"])
            // fetchVoiceNote()
        } catch {
            print("트랜스크라이버 초기화 오류: \(error)")
            onError?(error)
        }
    }
}
