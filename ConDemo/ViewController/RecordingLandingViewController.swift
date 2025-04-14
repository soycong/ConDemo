//
//  RecordingLandingViewController.swift
//  ConDemo
//
//  Created by 이명지 on 4/8/25.
//

import AVFoundation
import SnapKit
import UIKit

final class RecordingLandingViewController: UIViewController {
    // MARK: - Properties

    private let viewModel: RecordingLandingViewModel

    private let recordingLandingView: RecordingLandingView = .init()
    private let recordingMainViewController: RecordingMainViewController =
        .init(RecordingMainViewModel())

    // MARK: - Lifecycle

    init(viewModel: RecordingLandingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = recordingLandingView
        setAddTargets()
    }

    // MARK: - Functions

    private func setAddTargets() {
        recordingLandingView.startButton.addTarget(self, action: #selector(startButtonTapped),
                                                   for: .touchUpInside)
        recordingLandingView.communityButton.addTarget(self,
                                                       action: #selector(communityButtonTapped),
                                                       for: .touchUpInside)
        recordingLandingView.historyButton.addTarget(self,
                                                       action: #selector(historyButtonTapped),
                                                       for: .touchUpInside)
    }

    @objc
    private func startButtonTapped() {
        checkMicrophoneAuthorizationStatus { [weak self] in
            self?.navigationController?.pushViewController(self!.recordingMainViewController,
                                                           animated: true)
        }
    }

    @objc
    private func communityButtonTapped() {
//        navigationController?.pushViewController(TestViewController(), animated: true)
    }
    
    @objc
    private func historyButtonTapped() {
        let historyVC = HistoryViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }
}

extension RecordingLandingViewController {
    private func checkMicrophoneAuthorizationStatus(completion: @escaping () -> Void) {
        viewModel.onPermissionDenied = { [weak self] in
            self?.showDeniedAlert(title: "마이크 접근 권한 필요",
                                  message: "녹음을 위해 마이크 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.")
        }

        viewModel.onPermissionGranted = {
            completion()
        }

        viewModel.checkRecordingPermission()
    }

    private func showDeniedAlert(title: String, message: String) {
        let alert: UIAlertController = .init(title: title,
                                             message: message,
                                             preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
