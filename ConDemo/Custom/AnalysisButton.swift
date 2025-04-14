//
//  AnalysisButton.swift
//  ConDemo
//
//  Created by 이명지 on 4/11/25.
//

import UIKit

final class AnalysisButton: UIButton {
    
    init(iconName: String, title: String) {
        super.init(frame: .zero)
        
        setResizeIcon(imageName: iconName, imageSize: 20)
        setImageWithSpacing()
        setTitle(title, for: .normal)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.borderColor = UIColor.label.resolvedColor(with: traitCollection).cgColor
    }
    
    private func setupButton() {
        setImageWithSpacing()
        titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        setTitleColor(.label, for: .normal)
        titleLabel?.textAlignment = .center
        backgroundColor = .clear
        layer.borderColor = UIColor.label.resolvedColor(with: traitCollection).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 20
    }
}
