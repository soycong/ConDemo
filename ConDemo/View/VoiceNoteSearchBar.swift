//
//  VoiceNoteSearchBar.swift
//  ConDemo
//
//  Created by seohuibaek on 4/9/25.
//

import UIKit

final class VoiceNoteSearchBar: UISearchBar {
    init() {
        super.init(frame: .zero)

        searchBarStyle = .default

        backgroundImage = UIImage() // 위, 아래 줄 제거

        // 테두리 없애기 (추가 조치)
        // setBackgroundImage(UIImage(), for: .any, barMetrics: .default)

        // setSearchFieldBackgroundImage(UIImage(), for: .normal)

        searchTextField.backgroundColor = .backgroundGray
        searchTextField.layer.cornerRadius = 18
        searchTextField.clipsToBounds = true

        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.borderColor = UIColor.black.cgColor

        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true

        placeholder = "대화 내용 검색"
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
