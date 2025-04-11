//
//  RecordingLandingView.swift
//  ConDemo
//
//  Created by 이명지 on 4/8/25.
//

import UIKit

final class RecordingLandingView: UIView {
    // MARK: - Properties

    private(set) var startButton: CircleButton = .init(title: "Start")

    private(set) var historyButton: CircleButton = .init(title: "History")

    private(set) var communityButton: CircleButton = .init(title: "Community")

    private var adBannerImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.image = .landingAD
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .beigeGray
        imageView.tintColor = .label
        imageView.layer.cornerRadius = 14
        return imageView
    }()

    private lazy var bottomButtonStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [historyButton, communityButton])
        stackView.axis = .horizontal
        stackView.spacing = 21
        return stackView
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

        setupView()
        setupSubviews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func setupView() {
        backgroundColor = .systemBackground
    }

    private func setupSubviews() {
        [adBannerImageView,
         startButton,
         bottomButtonStackView,
         copyrightLabel].forEach {
            self.addSubview($0)
        }
    }

    private func setupConstraints() {
        adBannerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(96)
            make.horizontalEdges.equalToSuperview().inset(13)
            make.height.equalTo(72)
        }

        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(212)
        }

        historyButton.snp.makeConstraints { make in
            make.size.equalTo(98)
        }

        communityButton.snp.makeConstraints { make in
            make.size.equalTo(98)
        }

        bottomButtonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(startButton.snp.bottom).offset(55)
        }

        copyrightLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-34)
            make.centerX.equalToSuperview()
        }
    }
}
