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

    private var launchLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LaunchLogo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var adBannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .beigeGray
        imageView.tintColor = .black
        return imageView
    }()
    
    private var copyrightLabel: UILabel = {
        let label = UILabel()
        label.text = "Copyright © 2025 Ourvoices. All Rights Reserved"
        label.font = UIFont(name: "Pretendard-Medium", size: 7)
        label.textColor = .black
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLaunchScreen()
        setupSubviews()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLaunchLogo()
    }

    // MARK: - Functions

    private func setupLaunchScreen() {
        view.backgroundColor = .white
    }

    private func setupSubviews() {
        [launchLogoImageView,
         adBannerImageView,
         copyrightLabel].forEach {
            self.view.addSubview($0)
        }
    }

    private func setupConstraints() {
        launchLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(130)
        }

        copyrightLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-34)
            make.centerX.equalToSuperview()
        }

        adBannerImageView.snp.makeConstraints { make in
            make.top.equalTo(launchLogoImageView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(13)
            make.bottom.equalTo(copyrightLabel.snp.top).offset(-30)
        }
    }

    private func animateLaunchLogo() {
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
            self.launchLogoImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: { _ in
            self.fadeOutLogo()
        })
    }

    private func fadeOutLogo() {
        UIView.animate(withDuration: 0.8, animations: {
            self.launchLogoImageView.alpha = 0
        }, completion: { _ in
            self.navigateToMain()
        })
    }

    private func navigateToMain() {
        let userDefults: UserDefaults = .standard
        let isLandingRecordScreen = userDefults.bool(forKey: UserDefaultsKeys.landingRecordScreen)

        let newRootViewController: UIViewController =
            if isLandingRecordScreen {
                RecordingMainViewController()
            } else {
                CommunityMainViewController()
            }

        let transition: CATransition = .init()
        transition.duration = 0.5
        transition.type = .fade

        if let window = UIApplication.shared.windows.first {
            window.layer.add(transition, forKey: kCATransition)
            window.rootViewController = newRootViewController
            window.makeKeyAndVisible()
        } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first {
            window.layer.add(transition, forKey: kCATransition)
            window.rootViewController = newRootViewController
            window.makeKeyAndVisible()
        }
    }
}
