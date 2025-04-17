//
//  RecordingScriptViewModel.swift
//  ConDemo
//
//  Created by seohuibaek on 4/16/25.
//

import Foundation

final class RecordingScriptViewModel {
    // MARK: - Properties

    var onMessagesUpdated: (([Message]) -> Void)?
    var onError: ((Error) -> Void)?

    private var streamingTranscriber: StreamingTranscriber?

    private var messages: [Message] = [] {
        didSet {
            onMessagesUpdated?(messages)
        }
    }

    // MARK: - Functions
    
    func addMessage(_ message: Message) {
        messages.append(message)
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
