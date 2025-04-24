//
//  IncorrectUsage+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/23/25.
//
//

import Foundation
import CoreData


extension IncorrectUsage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IncorrectUsage> {
        return NSFetchRequest<IncorrectUsage>(entityName: "IncorrectUsage")
    }

    @NSManaged public var speakerA: NSObject?
    @NSManaged public var speakerB: NSObject?
    @NSManaged public var detailanaylsis: DetailedTranscriptAnalysis?
    @NSManaged public var incorrectexample: NSSet?

}

// MARK: Generated accessors for incorrectexample
extension IncorrectUsage {

    @objc(addIncorrectexampleObject:)
    @NSManaged public func addToIncorrectexample(_ value: IncorrectUsageExamples)

    @objc(removeIncorrectexampleObject:)
    @NSManaged public func removeFromIncorrectexample(_ value: IncorrectUsageExamples)

    @objc(addIncorrectexample:)
    @NSManaged public func addToIncorrectexample(_ values: NSSet)

    @objc(removeIncorrectexample:)
    @NSManaged public func removeFromIncorrectexample(_ values: NSSet)

}

extension IncorrectUsage : Identifiable {

}
