//
//  Message+CoreDataProperties.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//
//

import CoreData
import Foundation
import UIKit

public extension Message {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<Message> {
        NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged var id: String?
    @NSManaged var text: String?
    @NSManaged var isFromCurrentUser: Bool
    @NSManaged var timestamp: Date?
    @NSManaged var image: String?
    @NSManaged var audioURL: String?
    @NSManaged var audioData: Data?
    @NSManaged var analysis: Analysis?
}

extension Message: Identifiable { }

/// CoreData Entity를 MessageData로 변환
extension Message {
    func toMessageData() -> MessageData {
        let image: UIImage? = nil // 이미지 데이터 변환은 별도 구현 필요
        let audioURL = audioURL != nil ? URL(string: audioURL!) : nil

        return MessageData(id: id ?? UUID().uuidString,
                           text: text ?? "",
                           isFromCurrentUser: isFromCurrentUser,
                           timestamp: timestamp ?? Date(),
                           image: image,
                           audioURL: audioURL,
                           audioData: audioData)
    }
}
