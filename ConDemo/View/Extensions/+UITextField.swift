//
//  +UITextField.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit

extension UITextField {
    /// 왼쪽 여백 추가
    func addLeftPadding() {
        let paddingView: UIView = .init(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }

    /// 왼쪽 이미지 추가
    func addLeftImage(image: UIImage) {
        let leftImage: UIImageView = .init(frame: CGRect(x: 0, y: 0, width: image.size.width,
                                                         height: image.size.height))
        leftImage.image = image
        leftView = leftImage
        leftViewMode = .always
    }

    /// 왼쪽 시스템 이미지 추가
    func addLeftSystemImage(systemImageName: String) {
        let leftImage: UIImageView = .init(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        leftImage.image = UIImage(systemName: systemImageName)
        leftView = leftImage
        leftViewMode = .always
    }
}
