//
//  RecordingMainViewController.swift
//  ConDemo
//
//  Created by 이명지 on 4/9/25.
//

import UIKit

final class RecordingMainViewController: UIViewController {
    private let recordingMainView: RecordingMainView = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = recordingMainView
    }
}
