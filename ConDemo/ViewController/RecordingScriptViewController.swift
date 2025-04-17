//
//  RecordingScriptViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/16/25.
//

import UIKit

final class RecordingScriptViewController: UIViewController, TranscriptionDelegate {
    // MARK: - Properties

    private let recordingScriptView: RecordingScriptView = .init()
    private let viewModel: RecordingScriptViewModel = .init()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view = recordingScriptView
    }

    // TranscriptionDelegate 메서드 구현
    func didReceiveTranscription(text: String, speaker: String) {
        // 마침표를 기준으로 줄바꿈 적용
        let formattedText = text.replacingOccurrences(of: " \\. ",
                                                     with: ".\n",
                                                     options: .regularExpression)
                                .replacingOccurrences(of: " \\? ",
                                                     with: "?\n",
                                                     options: .regularExpression)
        
        let isCurrentUser = speaker == "0"
        let newMessage = Message(text: formattedText, isFromCurrentUser: isCurrentUser)
        
        // 기존 메시지에 추가하거나 새로운 메시지로 설정
        // viewModel.addMessage(newMessage)
        recordingScriptView.updateTextView(newMessage.text)
    }
}
