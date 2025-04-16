//
//  RecordingScriptViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/16/25.
//

import UIKit

final class RecordingScriptViewController: UIViewController {
    // MARK: - Properties

    private let recordingScriptView: RecordingScriptView = .init()
    private let viewModel: RecordingScriptViewModel = .init()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view = recordingScriptView
        // bind()
    }

    // MARK: - Functions

    private func bind() {
        viewModel.setupTranscriber()

        viewModel.onMessagesUpdated = { [weak self] messages in
            guard let self else {
                return
            }

            recordingScriptView.messages = messages
            recordingScriptView.scriptTextView.text = messages.last?.text
            
            // recordingScriptView.messageBubbleTableView.reloadData()

//            if let lastRow = messages.indices.last {
//                let indexPath: IndexPath = .init(row: lastRow, section: 0)
//                voiceNoteView.messageBubbleTableView.scrollToRow(at: indexPath, at: .bottom,
//                                                                 animated: true)
//            }
        }

        viewModel.onError = { [weak self] _ in
            // 에러 알러트 추가
        }
    }
}
