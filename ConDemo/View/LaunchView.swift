//
//  LaunchView.swift
//  ConDemo
//
//  Created by 이명지 on 4/8/25.
//

import UIKit

final class LaunchView: UIView {
    // MARK: - Properties

    private(set) var launchLogoImageView: UIImageView = {
        let imageView: UIImageView = .init(image: UIImage(named: "LaunchLogo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var adBannerImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .beigeGray
        imageView.tintColor = .label
        return imageView
    }()

    private var copyrightLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "Copyright © 2025 Ourvoices. All Rights Reserved"
        label.font = UIFont(name: "Pretendard-Medium", size: 7)
        label.textColor = .label
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLaunchScreen()
        setupSubviews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func setupLaunchScreen() {
        backgroundColor = .systemBackground
    }

    private func setupSubviews() {
        [launchLogoImageView,
         adBannerImageView,
         copyrightLabel].forEach {
            self.addSubview($0)
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
}
