//
//  +Date.swift
//  ConDemo
//
//  Created by 이명지 on 4/9/25.
//

import Foundation

extension Date {
    func toKoreaFormat() -> String {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd a HH:mm"
        return dateFormatter.string(from: self)
    }
}
