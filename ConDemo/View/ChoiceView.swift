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
        label.text = "보다 정확한 분석을 위해 본인이 했던 말을 선택해 주세요"
        label.textColor = .systemGray
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray.withAlphaComponent(0.2)
        return view
    }()
    
    private(set) var myCheckButton: UIButton = {
        let button = UIButton(type: .custom)
        let normalImage = UIImage(systemName: "checkmark.circle")?.withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
        let selectedImage = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.backgroundColor = .clear
        return button
    }()
    
    private let myLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = .label
        label.numberOfLines = 0
        
        let paragraphStyle: NSMutableParagraphStyle = .init()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .left
        
        let attributedString = NSAttributedString(
            string: "",
            attributes: [
                .paragraphStyle: paragraphStyle
            ]
        )
        
        label.attributedText = attributedString
        return label
    }()
    
    private(set) var yoursCheckButton: UIButton = {
        let button = UIButton(type: .custom)
        let normalImage = UIImage(systemName: "checkmark.circle")?.withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
        let selectedImage = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.backgroundColor = .clear
        return button
    }()
    
    private let yoursLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = .label
        label.numberOfLines = 0
        
        let paragraphStyle: NSMutableParagraphStyle = .init()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .left
        
        let attributedString = NSAttributedString(
            string: "",
            attributes: [
                .paragraphStyle: paragraphStyle
            ]
        )
        
        label.attributedText = attributedString
        return label
    }()
    
    private(set) var completeButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.setTitle("선택 완료", for: .normal)
        button.layer.cornerRadius = 14
        button.backgroundColor = .systemGray
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupText(userA: MessageData.dummyMessages[0].text, userB: MessageData.dummyMessages[1].text)
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
    }
    
    private func setupSubviews() {
        [
            choiceLabel,
            divider,
            myCheckButton,
            myLabel,
            yoursCheckButton,
            yoursLabel,
            completeButton
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        choiceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(107)
            make.horizontalEdges.equalToSuperview().inset(26)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(choiceLabel.snp.bottom).offset(14)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
        }
        
        myCheckButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(26)
            make.size.equalTo(20)
            make.top.equalTo(divider.snp.bottom).offset(50)
        }
        
        myLabel.snp.makeConstraints { make in
            make.top.equalTo(myCheckButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(26)
        }
        
        yoursCheckButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(26)
            make.size.equalTo(20)
            make.top.equalTo(myLabel.snp.bottom).offset(32)
        }
        
        yoursLabel.snp.makeConstraints { make in
            make.top.equalTo(yoursCheckButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(26)
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(26)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-45)
            make.height.equalTo(50)
        }
    }
}

extension ChoiceView {
    func setupText(userA: String, userB: String) {
        myLabel.text = userA
        yoursLabel.text = userB
    }
}
