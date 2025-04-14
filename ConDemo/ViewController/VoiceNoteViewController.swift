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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view = voiceNoteView
    }
}
