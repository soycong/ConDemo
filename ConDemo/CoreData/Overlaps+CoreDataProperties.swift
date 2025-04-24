//
//  Overlaps+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/23/25.
//
//

import Foundation
import CoreData


extension Overlaps {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Overlaps> {
        return NSFetchRequest<Overlaps>(entityName: "Overlaps")
    }

    @NSManaged public var count: Int64
    @NSManaged public var totalDuration: Double
    @NSManaged public var detailanaylsis: DetailedTranscriptAnalysis?

}

extension Overlaps : Identifiable {

}
