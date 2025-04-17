//
//  Analysis+CoreDataProperties.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//
//

import Foundation
import CoreData


extension Analysis {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Analysis> {
        return NSFetchRequest<Analysis>(entityName: "Analysis")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var contents: String?
    @NSManaged public var level: Int32
    @NSManaged public var messages: NSObject?
    @NSManaged public var log: NSObject?
    @NSManaged public var polls: NSObject?
    @NSManaged public var summary: NSObject?
    @NSManaged public var analysismessages: Message?
    @NSManaged public var analysislog: Log?
    @NSManaged public var analysispoll: Poll?
    @NSManaged public var analysissummary: Summary?

}

extension Analysis : Identifiable {

}
