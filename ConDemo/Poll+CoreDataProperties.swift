//
//  Poll+CoreDataProperties.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//
//

import Foundation
import CoreData


extension Poll {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Poll> {
        return NSFetchRequest<Poll>(entityName: "Poll")
    }

    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var contents: String?
    @NSManaged public var hers: String?
    @NSManaged public var his: String?
    @NSManaged public var option: NSObject?

}

extension Poll : Identifiable {

}
