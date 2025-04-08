//
//  CircleButton.swift
//  ConDemo
//
//  Created by 이명지 on 4/8/25.
//

import UIKit

final class CircleButton: UIButton {
    init(title: String, size: Int) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont(name: "BricolageGrotesque-SemiBold.ttf", size: 14)
        self.setTitleColor(.black, for: .normal)
        self.layer.frame.size = CGSize(width: size, height: size)
        self.layer.cornerRadius = self.layer.frame.size.width / 2
        self.backgroundColor = .clear
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
