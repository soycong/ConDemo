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
        
        view.backgroundColor = UIColor.systemGroupedBackground
    }

    // TranscriptionDelegate 메서드 구현
    func didReceiveTranscription(text: String) {
        recordingScriptView.updateTextView(text)
    }
}
