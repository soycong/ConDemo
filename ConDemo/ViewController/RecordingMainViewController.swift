//
//  RecordingMainViewController.swift
//  ConDemo
//
//  Created by 이명지 on 4/8/25.
//

import UIKit
import SnapKit

final class RecordingMainViewController: UIViewController {
    private var adBannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .beigeGray
        imageView.tintColor = .black
        imageView.layer.cornerRadius = 14
        return imageView
    }()
    
    private var startButton = CircleButton(title: "Start")
    
    private var historyButton = CircleButton(title: "History")
    
    private var communityButton = CircleButton(title: "Community")
    
    private lazy var bottomButtonStackView = {
        let stackView = UIStackView(arrangedSubviews: [historyButton, communityButton])
        stackView.axis = .horizontal
        stackView.spacing = 21
        return stackView
    }()
    
    private var copyrightLabel: UILabel = {
        let label = UILabel()
        label.text = "Copyright © 2025 Ourvoices. All Rights Reserved"
        label.font = UIFont(name: "Pretendard-Medium", size: 7)
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
    private func setupSubviews() {
        [
            adBannerImageView,
            startButton,
            bottomButtonStackView,
            copyrightLabel
        ].forEach {
            self.view.addSubview($0)
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
