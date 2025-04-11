//
//  +UITextField.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit

extension UITextField {
    // 왼쪽 여백 추가
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x:0, y:0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    // 왼쪽 이미지 추가
    func addLeftImage(image: UIImage) {
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        leftImage.image = image
        self.leftView = leftImage
        self.leftViewMode = .always
    }
    
    // 왼쪽 시스템 이미지 추가
    func addLeftSystemImage(systemImageName: String) {
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        leftImage.image = UIImage(systemName: systemImageName)
        self.leftView = leftImage
        self.leftViewMode = .always
    }
}
