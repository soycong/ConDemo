//
//  Analysis+CoreDataProperties.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//
//

import CoreData
import Foundation

public extension Analysis {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<Analysis> {
        NSFetchRequest<Analysis>(entityName: "Analysis")
    }

    @NSManaged var title: String?
    @NSManaged var date: Date?
    @NSManaged var contents: String?
    @NSManaged var level: Int32
    @NSManaged var messages: NSObject?
    @NSManaged var log: NSObject?
    @NSManaged var polls: NSObject?
    @NSManaged var summary: NSObject?
    @NSManaged var analysismessages: Message?
    @NSManaged var analysislog: Log?
    @NSManaged var analysispoll: Poll?
    @NSManaged var analysissummary: Summary?
}

extension Analysis: Identifiable { }
