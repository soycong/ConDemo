//
//  +String.swift
//  ConDemo
//
//  Created by seohuibaek on 4/9/25.
//

import Foundation
import UIKit

extension String {
    func makeAttributedString(_ searchText: String, font: UIFont? = UIFont.systemFont(ofSize: 14),
                              backgroundColor: UIColor = UIColor.gray.withAlphaComponent(0.3),
                              selectedHighlightColor: UIColor = UIColor.systemBlue.withAlphaComponent(0.5),
                              selectedTextColor: UIColor = .white,
                              currentMatchIndex: Int = -1,
                              textViewStyle: Bool = false
    ) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: self)
        
        // 모든 매치 찾기
        var allMatches: [NSRange] = []
        
        if let regex = try? NSRegularExpression(pattern: searchText, options: .caseInsensitive) {
            let range = NSRange(startIndex..., in: self)
            let matches = regex.matches(in: self, options: [], range: range)
            allMatches = matches.map { $0.range }
        }
        
        // 일반 배경색 적용
        for match in allMatches {
            attributedText.addAttributes([
                .backgroundColor: backgroundColor,
                .font: font as Any
            ], range: match)
        }
        
        // 선택된 매치에 다른 색상 적용
        if currentMatchIndex >= 0 && currentMatchIndex < allMatches.count {
            let selectedRange = allMatches[currentMatchIndex]
            attributedText.addAttributes([
                .backgroundColor: selectedHighlightColor,
                .foregroundColor: selectedTextColor
            ], range: selectedRange)
        }
        
        // 텍스트뷰 스타일 적용 (줄 간격 등)
        if textViewStyle {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10.0 // 줄 간격
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Pretendard-Medium", size: 14) ?? font as Any,
                .paragraphStyle: paragraphStyle
            ]
            
            attributedText.addAttributes(attributes, range: NSRange(location: 0, length: attributedText.length))
        }
        
        return attributedText
    }
}
