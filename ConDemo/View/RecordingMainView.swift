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

    // TODO: - 완료 버튼 너무 좁음
    private(set) var recordButton: UIButton = {
        let button: UIButton = .init()
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
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

    private(set) var dateLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = .label
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        return label
    }()

    private(set) var timeLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = .label
        label.font = UIFont(name: "Pretendard-SemiBold", size: 26)
        return label
    }()

    private(set) var dimLayer: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .black
        view.isHidden = true
        return view
    }()

    private let recordImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.image = .record
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSubviews()
        setupConstraints()
        setupTime()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.label.resolvedColor(with: traitCollection).cgColor
    }

    // MARK: - Functions

    private func setupView() {
        backgroundColor = .baseBackground
        recordButton.layer.borderColor = UIColor.label.resolvedColor(with: traitCollection).cgColor
    }

    private func setupSubviews() {
        [dateLabel,
         timeLabel,
         recordImageView,
         saveButton,
         completeButton,
         dimLayer,
         recordButton].forEach {
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

        recordButton.snp.makeConstraints { make in
            make.top.equalTo(recordImageView.snp.bottom).offset(126)
            make.centerX.equalToSuperview()
            make.height.equalTo(38)
            make.width.equalTo(108)
        }

        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(recordButton.snp.centerY)
            make.trailing.equalTo(recordButton.snp.leading).offset(-26)
        }

        completeButton.snp.makeConstraints { make in
            make.centerY.equalTo(recordButton.snp.centerY)
            make.leading.equalTo(recordButton.snp.trailing).offset(26)
        }

        dimLayer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupTime() {
        timeLabel.text = "00:38:02"
    }
}
