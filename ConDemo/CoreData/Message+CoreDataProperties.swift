//
//  Message+CoreDataProperties.swift
//  ConDemo
//
//  Created by 이명지 on 4/17/25.
//
//

import Foundation
import CoreData
import UIKit


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var audioData: Data?
    @NSManaged public var audioURL: String?
    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var isFromCurrentUser: Bool
    @NSManaged public var text: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var analysis: Analysis?

}

extension Message : Identifiable {

}

extension Message {
    func toMessageData() -> MessageData {
        // image 문자열을 UIImage로 변환 (이미지 경로나 이름이 저장되어 있다고 가정)
        var uiImage: UIImage? = nil
        if let imageName = self.image {
            uiImage = UIImage(named: imageName)
        }
        
        // audioURL 문자열을 URL로 변환
        var audioURL: URL? = nil
        if let urlString = self.audioURL, let url = URL(string: urlString) {
            audioURL = url
        }
        
        return MessageData(
            id: self.id ?? UUID().uuidString,
            text: self.text ?? "",
            isFromCurrentUser: self.isFromCurrentUser,
            timestamp: self.timestamp ?? Date(),
            image: uiImage,
            audioURL: audioURL,
            audioData: self.audioData
        )
    }
}
