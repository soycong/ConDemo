//
//  VoiceNoteViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/9/25.
//

import UIKit

final class VoiceNoteViewController: UIViewController {
    // MARK: - Properties

    private let voiceNoteView: VoiceNoteView = .init()
    private let viewModel: VoiceNoteViewModel = .init()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view = voiceNoteView
        // bind()
    }

    // MARK: - Functions

    private func bind() {
        viewModel.setupTranscriber()

        viewModel.onMessagesUpdated = { [weak self] messages in
            guard let self else {
                return
            }

            voiceNoteView.messages = messages
            voiceNoteView.messageBubbleTableView.reloadData()

            if let lastRow = messages.indices.last {
                let indexPath: IndexPath = .init(row: lastRow, section: 0)
                voiceNoteView.messageBubbleTableView.scrollToRow(at: indexPath, at: .bottom,
                                                                 animated: true)
            }
        }

        viewModel.onError = { [weak self] _ in
            // 에러 알러트 추가
        }
    }
}
