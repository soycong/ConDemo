//
//  RecordingLandingViewController.swift
//  ConDemo
//
//  Created by 이명지 on 4/8/25.
//

import SnapKit
import UIKit

final class RecordingLandingViewController: UIViewController {
    // MARK: - Properties

    private let recordingLandingView: RecordingLandingView = .init()
    private let recordingMainViewController: RecordingMainViewController = .init()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view = recordingLandingView
        setAddTargets()
    }

    // MARK: - Functions

    private func setAddTargets() {
        recordingLandingView.startButton.addTarget(self, action: #selector(startButtonTapped),
                                                   for: .touchUpInside)
    }

    @objc
    private func startButtonTapped() {
        navigationController?.pushViewController(recordingMainViewController, animated: true)
    }
}
