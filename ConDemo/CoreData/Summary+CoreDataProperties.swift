//
//  Summary+CoreDataProperties.swift
//  ConDemo
//
//  Created by 이명지 on 4/17/25.
//
//

import Foundation
import CoreData


extension Summary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Summary> {
        return NSFetchRequest<Summary>(entityName: "Summary")
    }

    @NSManaged public var contents: String?
    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var analysis: Analysis?

}

extension Summary : Identifiable {

}
