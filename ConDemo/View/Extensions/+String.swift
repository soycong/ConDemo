//
//  +String.swift
//  ConDemo
//
//  Created by seohuibaek on 4/9/25.
//

import Foundation
import UIKit

extension String {
    // 검색한 텍스트 속성 변경
    // - Parameters:
    //   - searchText: 검색할 문자열
    //   - font: 변경할 폰트
    //   - color: 변경할 색상
    //   - isAll: 모든 동일한 텍스트 변경 여부 (default = true)
    // - Returns: 속성이 적용된 NSAttributedString

    func makeAttributedString(_ searchText: String, font: UIFont? = UIFont.systemFont(ofSize: 14),
                              backgroundColor: UIColor? = .gray,
                              isAll: Bool = true) -> NSAttributedString {
        let attributedText: NSMutableAttributedString = .init(string: self)
        if let regex = try? NSRegularExpression(pattern: searchText, options: .caseInsensitive) {
            let range: NSRange = .init(startIndex..., in: self)
            let matches = regex.matches(in: self, options: [], range: range)

            if isAll {
                for match in matches {
                    var attributes: [NSAttributedString.Key: Any] = [.font: font]
                    if let backgroundColor {
                        attributes[.backgroundColor] = backgroundColor
                    }
                    attributedText.addAttributes(attributes, range: match.range)
                }
            } else if let firstItem = matches.first {
                var attributes: [NSAttributedString.Key: Any] = [.font: font]
                if let backgroundColor {
                    attributes[.backgroundColor] = backgroundColor
                }
                attributedText.addAttributes(attributes, range: firstItem.range)
            }
        }
        return attributedText
    }
}
