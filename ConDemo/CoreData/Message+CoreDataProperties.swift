//
//  Message+CoreDataProperties.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//
//

import Foundation
import CoreData
import UIKit


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var isFromCurrentUser: Bool
    @NSManaged public var timestamp: Date?
    @NSManaged public var image: String?
    @NSManaged public var audioURL: String?
    @NSManaged public var audioData: Data?
    @NSManaged public var analysis: Analysis?

}

extension Message : Identifiable {

}

// CoreData Entity를 MessageData로 변환
extension Message {
    func toMessageData() -> MessageData {
        let image: UIImage? = nil // 이미지 데이터 변환은 별도 구현 필요
        let audioURL = self.audioURL != nil ? URL(string: self.audioURL!) : nil
        
        return MessageData(
            id: self.id ?? UUID().uuidString,
            text: self.text ?? "",
            isFromCurrentUser: self.isFromCurrentUser,
            timestamp: self.timestamp ?? Date(),
            image: image,
            audioURL: audioURL,
            audioData: self.audioData
        )
    }
}
