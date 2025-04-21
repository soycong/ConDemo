//
//  ChatGPTResponse.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//

import Foundation

struct ChatGPTResponse: Decodable {
    // MARK: - Nested Types

    struct Choice: Decodable {
        // MARK: - Nested Types

        enum CodingKeys: String, CodingKey {
            case index
            case message
            case finishReason = "finish_reason"
        }

        // MARK: - Properties

        let index: Int
        let message: Message
        let finishReason: String?
    }

    struct Message: Decodable {
        let role: String
        let content: String
    }

    // MARK: - Properties

    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
}
