//
//  MessageData.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import CoreData
import Foundation
import UIKit

struct MessageData {
    // MARK: - Properties

    let id: String?
    let text: String
    let isFromCurrentUser: Bool
    let timestamp: Date?
    let image: UIImage?
    let audioURL: URL?
    let audioData: Data?

    // MARK: - Lifecycle

    init(id: String = UUID().uuidString, text: String, isFromCurrentUser: Bool,
         timestamp: Date = Date(), image: UIImage? = nil, audioURL: URL? = nil,
         audioData: Data? = nil) {
        self.id = id
        self.text = text
        self.isFromCurrentUser = isFromCurrentUser
        self.timestamp = timestamp
        self.image = image
        self.audioURL = audioURL
        self.audioData = audioData
    }
}

// MARK: - 더미 데이터

extension MessageData {
    static var dummyMessages: [MessageData] {
        let calendar: Calendar = .current
        let now: Date = .init()

        return [MessageData(text: "안녕하세요? TROBL AI입니다.", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -120, to: now)!)]
    }
}
