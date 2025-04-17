//
//  Log+CoreDataProperties.swift
//  ConDemo
//
//  Created by 이명지 on 4/17/25.
//
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var date: Date?
    @NSManaged public var contents: String?
    @NSManaged public var analysis: Analysis?

}

extension Log : Identifiable {

}
