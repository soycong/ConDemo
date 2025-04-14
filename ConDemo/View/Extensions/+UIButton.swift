//
//  +UIButton.swift
//  ConDemo
//
//  Created by seohuibaek on 4/9/25.
//

import UIKit

extension UIButton {
    /// 시스템이미지 사용
    func setButtonWithSystemImage(imageName: String, imageSize: CGFloat = 20) {
        let config = UIImage.SymbolConfiguration(pointSize: imageSize, weight: .medium)
        if let image = UIImage(systemName: imageName, withConfiguration: config) {
            setImage(image, for: .normal)
            tintColor = .black
        }
    }

    func setImageWithSpacing() {
        imageEdgeInsets = .init(top: 0, left: -8, bottom: 0, right: 0)
        titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
    }

//    func setAsIconButton(size: CGFloat = 20) {
//        backgroundColor = .systemBackground.withAlphaComponent(0.8)
//        layer.cornerRadius = size / 2
//        frame.size = CGSize(width: size, height: size) // 버튼 크기 설정
//        layer.masksToBounds = false
//    }
}
