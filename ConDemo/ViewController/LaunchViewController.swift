//
//  LaunchViewController.swift
//  ConDemo
//
//  Created by 이명지 on 4/8/25.
//

import SnapKit
import UIKit

final class LaunchViewController: UIViewController {
    // MARK: - Properties

    private var launchView: LaunchView = .init()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view = launchView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLaunchLogo()
    }

    // MARK: - Functions

    private func animateLaunchLogo() {
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
            self.launchView.launchLogoImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: { _ in
            self.fadeOutLogo()
        })
    }

    private func fadeOutLogo() {
        UIView.animate(withDuration: 0.8, animations: {
            self.launchView.launchLogoImageView.alpha = 0
        }, completion: { _ in
            self.navigateToMain()
        })
    }

    private func navigateToMain() {
        let userDefults: UserDefaults = .standard
        let isLandingRecordScreen = userDefults.bool(forKey: UserDefaultsKeys.landingRecordScreen)

        // 테스트 코드
        let newRootViewController: UIViewController =
            RecordingLandingViewController(viewModel: RecordingLandingViewModel())
//            if isLandingRecordScreen {
//                RecordingLandingViewController(viewModel: RecordingLandingViewModel())
//            } else {
//                RecordingLandingViewController(viewModel: RecordingLandingViewModel())
//            }

        let transition: CATransition = .init()
        transition.duration = 0.5
        transition.type = .fade

        if let window = UIApplication.shared.windows.first {
            window.layer.add(transition, forKey: kCATransition)
            window
                .rootViewController =
                UINavigationController(rootViewController: newRootViewController)
            window.makeKeyAndVisible()
        } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first {
            window.layer.add(transition, forKey: kCATransition)
            window
                .rootViewController =
                UINavigationController(rootViewController: newRootViewController)
            window.makeKeyAndVisible()
        }
    }
}
