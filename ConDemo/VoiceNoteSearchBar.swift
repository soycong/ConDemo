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

        searchBarStyle = .minimal

        searchTextField.backgroundColor = .backgroundGray
        searchTextField.layer.cornerRadius = 20
        searchTextField.clipsToBounds = true
        
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.borderColor = UIColor.gray.cgColor
        
        placeholder = "대화 내용 검색"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
