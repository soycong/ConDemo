//
//  CircleButton.swift
//  ConDemo
//
//  Created by 이명지 on 4/8/25.
//

import UIKit

final class CircleButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)

        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: "BricolageGrotesque-SemiBold", size: 14)
        setTitleColor(.label, for: .normal)
        backgroundColor = .clear
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.label.cgColor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
}
