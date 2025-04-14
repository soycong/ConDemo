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
        imageView.image = UIImage(named: "launchAD")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
        copyrightLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-34)
            make.centerX.equalToSuperview()
        }

        adBannerImageView.snp.makeConstraints { make in
            make.bottom.equalTo(copyrightLabel.snp.top).offset(-25)
            make.horizontalEdges.equalToSuperview().inset(13)
            make.height.equalTo(241)
        }

        launchLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(adBannerImageView.snp.top).offset(-147)
            make.size.equalTo(130)
        }
    }
}
