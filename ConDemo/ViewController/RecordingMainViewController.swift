//
//  RecordingMainViewController.swift
//  ConDemo
//
//  Created by 이명지 on 4/8/25.
//

import SnapKit
import UIKit

final class RecordingMainViewController: UIViewController {
    // MARK: - Properties

    private var recordingMainView: RecordingMainView = .init()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view = recordingMainView
    }
}
