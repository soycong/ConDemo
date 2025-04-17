//
//  AnalysisButton.swift
//  ConDemo
//
//  Created by 이명지 on 4/11/25.
//

import UIKit

final class AnalysisButton: UIButton {
    // MARK: - Properties
    
    private var originalBackgroundColor: UIColor = .clear
    
    // MARK: - Lifecycle

    init(iconName: String, title: String) {
        super.init(frame: .zero)

        setResizeIcon(imageName: iconName, imageSize: 20)
        setImageWithSpacing()
        setTitle(title, for: .normal)
        setupButton()
        setupTapAnimation()
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

    private func setupButton() {
        setImageWithSpacing()
        titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        setTitleColor(.label, for: .normal)
        titleLabel?.textAlignment = .center
        backgroundColor = .clear
        layer.borderColor = UIColor.label.resolvedColor(with: traitCollection).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 20
        
        // 원래 배경색 저장
        originalBackgroundColor = .clear
    }
    
    private func setupTapAnimation() {
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchDragExit, .touchCancel])
    }
    
    @objc private func touchDown() {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = .pointBlue
            
            // 살짝 작아지는 효과
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        })
    }
    
    @objc private func touchUp() {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = self.originalBackgroundColor
            
            // 원래 크기로 복원
            self.transform = .identity
        })
    }
}
