//
//  MessageViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit

final class MessageViewController: UIViewController {
    private let messageView = MessageView()
    private var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = messageView
        
        loadDummyMessages() // 더미 데이터 추후 삭제 예정
    }
}

// 더미 데이터 삭제 예정
extension MessageViewController {
    private func loadDummyMessages() {
        let dummyMessages: [Message] = [
            Message(text: "반가워요. 오늘 어떻게 지내세요?", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3600 * 23)),
            Message(text: "잘 지내고 있어요. 프로젝트는 어떻게 진행되고 있나요?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600 * 22)),
            Message(text: "거의 완성 단계에 있어요. 채팅 UI만 마무리하면 됩니다.", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3600 * 5)),
            Message(text: "멋지네요! 언제쯤 완성될 것 같아요?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600 * 4)),
            Message(text: "이번 주 금요일까지는 마무리할 계획입니다.", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3600 * 3)),
            Message(text: "정말 기대되네요! 완성되면 꼭 알려주세요.", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600 * 2)),
            Message(text: "네, 물론이죠! 완성되면 바로 알려드릴게요.", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3600 * 1)),
            Message(text: "혹시 기능 중에 오디오 메시지 기능도 포함되나요?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-1800)),
            Message(text: "다음 버전에서 추가할 예정입니다. 우선은 텍스트와 이미지 메시지에 집중하고 있어요.", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-1200)),
            Message(text: "안녕하세요!", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600 * 24)),
            Message(text: "반가워요. 오늘 어떻게 지내세요?", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3600 * 23)),
            Message(text: "잘 지내고 있어요. 프로젝트는 어떻게 진행되고 있나요?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600 * 22)),
            Message(text: "거의 완성 단계에 있어요. 채팅 UI만 마무리하면 됩니다.", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3600 * 5)),
            Message(text: "멋지네요! 언제쯤 완성될 것 같아요?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600 * 4)),
            Message(text: "이번 주 금요일까지는 마무리할 계획입니다.", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3600 * 3)),
            Message(text: "정말 기대되네요! 완성되면 꼭 알려주세요.", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600 * 2)),
            Message(text: "네, 물론이죠! 완성되면 바로 알려드릴게요.", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3600 * 1)),
            Message(text: "혹시 기능 중에 오디오 메시지 기능도 포함되나요?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-1800)),
            Message(text: "다음 버전에서 추가할 예정입니다. 우선은 텍스트와 이미지 메시지에 집중하고 있어요.", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-1200))
        ]
        
        messages.append(contentsOf: dummyMessages)
        messageView.messages = messages
    }
}
