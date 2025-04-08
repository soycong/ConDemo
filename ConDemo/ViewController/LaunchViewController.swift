//
//  LaunchViewController.swift
//  ConDemo
//
//  Created by 이명지 on 4/8/25.
//

import UIKit
import SnapKit

final class LaunchViewController: UIViewController {
    
    private var launchLogoImageView = UIImageView(image: UIImage(named: "LaunchLogo"))
    private var adBannerImageView = UIImageView()
    private var copyrightLabel = UILabel()
    
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
    
    private func setupLaunchScreen() {
        self.view.backgroundColor = .white
        launchLogoImageView = UIImageView(image: UIImage(named: "LaunchLogo"))
        launchLogoImageView.contentMode = .scaleAspectFit
        
        adBannerImageView.contentMode = .scaleAspectFit
        adBannerImageView.backgroundColor = UIColor(red: 249/255.0, green: 245/255.0, blue: 242/255.0, alpha: 1.0)
        adBannerImageView.tintColor = .black
        
        
        copyrightLabel.text = "Copyright © 2025 Ourvoices. All Rights Reserved"
        copyrightLabel.font = UIFont(name: "Pretendard-Medium", size: 7)
        copyrightLabel.textColor = .black
    }
    
    private func setupSubviews() {
        [
            launchLogoImageView,
            adBannerImageView,
            copyrightLabel
        ].forEach {
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
        let userDefults = UserDefaults.standard
        let isLandingRecordScreen = userDefults.bool(forKey: UserDefaultsKeys.landingRecordScreen)
        
        let newRootViewController: UIViewController
        
        if isLandingRecordScreen {
            newRootViewController = RecordingMainViewController()
        } else {
            newRootViewController = CommunityMainViewController()
        }
        
        let transition = CATransition()
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
