//
//  Poll+CoreDataProperties.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//
//

import CoreData
import Foundation

public extension Poll {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<Poll> {
        NSFetchRequest<Poll>(entityName: "Poll")
    }

    @NSManaged var date: Date?
    @NSManaged var title: String?
    @NSManaged var contents: String?
    @NSManaged var hers: String?
    @NSManaged var his: String?
    @NSManaged var option: NSObject?
}

extension Poll: Identifiable { }
