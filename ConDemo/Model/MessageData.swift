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
    var isFromCurrentUser: Bool
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

extension MessageData {
    mutating func switchUser() {
        self.isFromCurrentUser.toggle()
    }
}

// MARK: - 더미 데이터

extension MessageData {
    static var dummyMessages: [MessageData] {
        let calendar: Calendar = .current
        let now: Date = .init()

        return [
            MessageData(text: "여보, 오늘도 집안일 다 내가 했어. 당신은 왜 도와주지 않는 거야?", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -118, to: now)!),
            
            MessageData(text: "나도 일 끝나고 너무 피곤해서 그랬어. 내일은 도와줄게.", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -116, to: now)!),
            
            MessageData(text: "항상 내일, 내일 그러면서 안 도와주잖아. 나도 일하고 와서 피곤하다고.", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -115, to: now)!),
            
            MessageData(text: "당신 일과 내 일이 같냐? 내가 얼마나 스트레스 받는데...", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -113, to: now)!),
            
            MessageData(text: "또 그 얘기야? 내 일이 편하다고 생각하는 거야?", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -112, to: now)!)
        ]
    }
}
