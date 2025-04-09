//
//  RecordingMainView.swift
//  ConDemo
//
//  Created by 이명지 on 4/9/25.
//

import SnapKit
import UIKit

final class RecordingMainView: UIView {
    // MARK: - Properties

    private(set) var recordButton: UIButton = {
        let button: UIButton = .init()
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        button.backgroundColor = .clear
        return button
    }()

    private(set) var saveButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    private(set) var completeButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    private let dateLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = .label
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        return label
    }()

    private let timeLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = .label
        label.font = UIFont(name: "Pretendard-SemiBold", size: 26)
        return label
    }()

    private let recordImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.image = .record
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [saveButton, recordButton,
                                                              completeButton])
        stackView.axis = .horizontal
        stackView.spacing = 26
        return stackView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSubviews()
        setupConstraints()
        setupTest()
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
        [dateLabel,
         timeLabel,
         recordImageView,
         buttonStackView].forEach {
            addSubview($0)
        }
    }

    private func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(timeLabel.snp.top).offset(-7)
            make.centerX.equalToSuperview()
        }

        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(recordImageView.snp.top).offset(-60)
            make.centerX.equalToSuperview()
        }

        recordImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(212)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(recordImageView.snp.bottom).offset(126)
            make.centerX.equalToSuperview()
            make.height.equalTo(38)
        }

        recordButton.snp.makeConstraints { make in
            make.width.equalTo(108)
        }
    }

    private func setupTest() {
        dateLabel.text = "2025.04.07 오후 14:20"
        timeLabel.text = "00:38:02"
    }
}
