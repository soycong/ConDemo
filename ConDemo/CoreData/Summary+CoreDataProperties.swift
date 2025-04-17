//
//  Summary+CoreDataProperties.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//
//

import CoreData
import Foundation

public extension Summary {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<Summary> {
        NSFetchRequest<Summary>(entityName: "Summary")
    }

    @NSManaged var title: String?
    @NSManaged var contents: String?
    @NSManaged var date: Date?
}

extension Summary: Identifiable { }
