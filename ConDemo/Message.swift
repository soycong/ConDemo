//
//  Message.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import Foundation
import UIKit

struct Message {
    let id: String
    let text: String
    let isFromCurrentUser: Bool
    let timestamp: Date
    let image: UIImage?
    
    init(id: String = UUID().uuidString, text: String, isFromCurrentUser: Bool, timestamp: Date = Date(), image: UIImage? = nil) {
        self.id = id
        self.text = text
        self.isFromCurrentUser = isFromCurrentUser
        self.timestamp = timestamp
        self.image = image
    }
}

// MARK: - 더미 데이터
extension Message {
    static var dummyMessages: [Message] {
        let calendar = Calendar.current
        let now = Date()
        
        return [
            Message(text: "안녕하세요!", isFromCurrentUser: false, timestamp: calendar.date(byAdding: .minute, value: -30, to: now)!),
            Message(text: "반갑습니다. 어떻게 지내세요?", isFromCurrentUser: true, timestamp: calendar.date(byAdding: .minute, value: -28, to: now)!),
            Message(text: "잘 지내고 있어요. 프로젝트는 어떻게 진행되고 있나요? 잘 지내고 있어요. 프로젝트는 어떻게 진행되고 있나요?", isFromCurrentUser: false, timestamp: calendar.date(byAdding: .minute, value: -25, to: now)!),
            Message(text: "거의 완성 단계예요! 몇 가지 버그만 수정하면 됩니다.", isFromCurrentUser: true, timestamp: calendar.date(byAdding: .minute, value: -20, to: now)!),
            Message(text: "와, 정말 빨리 진행되고 있네요. 축하해요!", isFromCurrentUser: false, timestamp: calendar.date(byAdding: .minute, value: -18, to: now)!),
            Message(text: "감사합니다! 다음 주에 출시할 예정이에요.", isFromCurrentUser: true, timestamp: calendar.date(byAdding: .minute, value: -15, to: now)!),
            Message(text: "출시 후 피드백 공유해 주세요!", isFromCurrentUser: false, timestamp: calendar.date(byAdding: .minute, value: -5, to: now)!),
            Message(text: "안녕하세요!", isFromCurrentUser: false, timestamp: calendar.date(byAdding: .minute, value: -30, to: now)!),
            Message(text: "반갑습니다. 어떻게 지내세요?", isFromCurrentUser: true, timestamp: calendar.date(byAdding: .minute, value: -28, to: now)!),
            Message(text: "잘 지내고 있어요. 프로젝트는 어떻게 진행되고 있나요?", isFromCurrentUser: false, timestamp: calendar.date(byAdding: .minute, value: -25, to: now)!),
            Message(text: "거의 완성 단계예요! 몇 가지 버그만 수정하면 됩니다.", isFromCurrentUser: true, timestamp: calendar.date(byAdding: .minute, value: -20, to: now)!),
            Message(text: "와, 정말 빨리 진행되고 있네요. 축하해요!", isFromCurrentUser: false, timestamp: calendar.date(byAdding: .minute, value: -18, to: now)!),
            Message(text: "감사합니다! 다음 주에 출시할 예정이에요.", isFromCurrentUser: true, timestamp: calendar.date(byAdding: .minute, value: -15, to: now)!),
            Message(text: "출시 후 피드백 공유해 주세요!", isFromCurrentUser: false, timestamp: calendar.date(byAdding: .minute, value: -5, to: now)!)
        ]
    }
}
