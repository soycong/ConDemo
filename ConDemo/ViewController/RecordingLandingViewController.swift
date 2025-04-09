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

    private var recordingLandingView: RecordingLandingView = .init()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view = recordingLandingView
    }
}
