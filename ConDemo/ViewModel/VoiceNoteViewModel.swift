//
//  VoiceNoteViewModel.swift
//  ConDemo
//
//  Created by seohuibaek on 4/15/25.
//

import Foundation

final class VoiceNoteViewModel {
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

    func setupTranscriber() {
        do {
            streamingTranscriber = try StreamingTranscriber.parse(["--format", "flac",
                                                 "--path", "testAudio.flac"])
            fetchVoiceNote()
        } catch {
            print("트랜스크라이버 초기화 오류: \(error)")
            onError?(error)
        }
    }

    private func fetchVoiceNote() {
        guard let streamingTranscriber else {
            return
        }

        Task {
            do {
                var lastUpdateTime: TimeInterval = 0

                for await (text, speaker) in streamingTranscriber
                    .transcribeWithMessageStream(encoding: streamingTranscriber.getMediaEncoding()) {
                    let now = Date().timeIntervalSince1970

                    if now - lastUpdateTime >= 1.0 { // 1초마다 UI업데이트
                        await MainActor.run {
                            print("실시간 대화 시작")
                            let isCurrentUser = speaker == "0"
                            let newMessage: Message = .init(text: text,
                                                            isFromCurrentUser: isCurrentUser)

                            messages.append(newMessage)
                        }
                        lastUpdateTime = now
                    }
                }
            } catch {
                await MainActor.run {
                    print("음성 변환 오류: \(error)")
                    onError?(error)
                }
            }
        }
    }
}
