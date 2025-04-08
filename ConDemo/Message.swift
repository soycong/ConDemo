//
//  Message.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import Foundation

struct Message {
    let id: String
    let text: String
    let isFromCurrentUser: Bool
    let timestamp: Date
    
    init(id: String = UUID().uuidString, text: String, isFromCurrentUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.isFromCurrentUser = isFromCurrentUser
        self.timestamp = timestamp
    }
}
