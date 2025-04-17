//
//  Message+CoreDataProperties.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//
//

import Foundation
import CoreData


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

}

extension Message : Identifiable {

}
