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
        
        // 시리로 실행되었는지 확인
        let launchedFromSiri = UserDefaults.standard.bool(forKey: "LaunchFromSiri")
        
        // 플래그 초기화
        UserDefaults.standard.set(false, forKey: "LaunchFromSiri")
        
        if launchedFromSiri {
            // 시리에서 실행된 경우, 애니메이션 실행 후 RecordingMainViewController로 바로 이동
            animateLaunchLogoWithSiri()
        } else {
            // 일반 실행의 경우 기존 애니메이션 실행
            animateLaunchLogo()
        }
    }
    
    private func animateLaunchLogoWithSiri() {
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
            self.launchView.launchLogoImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: { _ in
            // 시리 실행 경로: RecordingLandingViewController -> RecordingMainViewController
            let landingVM = RecordingLandingViewModel()
            let landingVC = RecordingLandingViewController(viewModel: landingVM)
            let navController = UINavigationController(rootViewController: landingVC)
            
            // 윈도우 가져오기 (iOS 15 이상 호환)
            let window = self.getKeyWindow()
            
            let transition: CATransition = .init()
            transition.duration = 0.5
            transition.type = .fade
            window?.layer.add(transition, forKey: kCATransition)
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
            
            // 0.1초 후 RecordingMainViewController로 이동
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let recordingVM = RecordingMainViewModel()
                let recordingVC = RecordingMainViewController(recordingVM)
                landingVC.navigationController?.pushViewController(recordingVC, animated: false)
            }
        })
    }

    private func animateLaunchLogo() {
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
            self.launchView.launchLogoImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: { _ in
            // 일반 실행 경로: 바로 RecordingLandingViewController로 이동
            let landingVM = RecordingLandingViewModel()
            let landingVC = RecordingLandingViewController(viewModel: landingVM)
            
            let transition: CATransition = .init()
            transition.duration = 0.5
            transition.type = .fade

            let window = self.getKeyWindow()
            window?.layer.add(transition, forKey: kCATransition)
            window?.rootViewController = UINavigationController(rootViewController: landingVC)
            window?.makeKeyAndVisible()
        })
    }

    // 윈도우 가져오는 헬퍼 메서드 추가
    private func getKeyWindow() -> UIWindow? {
        if #available(iOS 15.0, *) {
            // iOS 15 이상
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        } else {
            // iOS 15 미만
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        }
    }
    
    // MARK: - Functions

    private func navigateToMain() {
        let userDefults: UserDefaults = .standard
        _ = userDefults.bool(forKey: UserDefaultsKeys.landingRecordScreen)

        // 테스트 코드
        let newRootViewController: UIViewController =
            RecordingLandingViewController(viewModel: RecordingLandingViewModel())

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
