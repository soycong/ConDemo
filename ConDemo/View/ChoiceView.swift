//
//  ChoiceView.swift
//  ConDemo
//
//  Created by 이명지 on 4/21/25.
//

import UIKit

final class ChoiceView: UIView {
    private let choiceLabel: UILabel = {
        let label = UILabel()
        label.text = "내가 한 말을 선택해주세요."
        label.textColor = .label
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let userAwordsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.titleLabel?.textColor = .label
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.layer.borderWidth = 1
        return button
    }()
    
    private let userBwordsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.titleLabel?.textColor = .label
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.layer.borderWidth = 1
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [choiceLabel, userAwordsButton, userBwordsButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // border Color에 Dynamic Color 적용
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.label.resolvedColor(with: traitCollection).cgColor
    }
}

extension ChoiceView {
    private func setupView() {
        backgroundColor = .systemBackground
        [
            userAwordsButton,
            userBwordsButton
        ].forEach {
            $0.layer.borderColor = UIColor.label.resolvedColor(with: traitCollection).cgColor
        }
    }
    
    private func setupSubviews() {
        [
            stackView
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        stackView.setCustomSpacing(16, after: choiceLabel)
    }
}

extension ChoiceView {
    func setupButtonsText(userA: String, userB: String) {
        userAwordsButton.setTitle(userA, for: .normal)
        userBwordsButton.setTitle(userB, for: .normal)
    }
}
