//
//  IncorrectUsageExamples+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/23/25.
//
//

import Foundation
import CoreData


extension IncorrectUsageExamples {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IncorrectUsageExamples> {
        return NSFetchRequest<IncorrectUsageExamples>(entityName: "IncorrectUsageExamples")
    }

    @NSManaged public var count: Int64
    @NSManaged public var examples: NSObject?
    @NSManaged public var incorrect: IncorrectUsage?

}

extension IncorrectUsageExamples : Identifiable {

}
