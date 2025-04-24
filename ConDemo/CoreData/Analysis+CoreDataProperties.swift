//
//  Analysis+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/23/25.
//
//

import Foundation
import CoreData


extension Analysis {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Analysis> {
        return NSFetchRequest<Analysis>(entityName: "Analysis")
    }

    @NSManaged public var contents: String?
    @NSManaged public var date: Date?
    @NSManaged public var level: Int32
    @NSManaged public var log: NSObject?
    @NSManaged public var messages: NSObject?
    @NSManaged public var polls: NSObject?
    @NSManaged public var summary: NSObject?
    @NSManaged public var title: String?
    @NSManaged public var analysislog: NSSet?
    @NSManaged public var analysismessages: NSSet?
    @NSManaged public var analysispolls: NSSet?
    @NSManaged public var analysissummary: NSSet?
    @NSManaged public var analysisdetailtranscript: DetailedTranscriptAnalysis?

}

// MARK: Generated accessors for analysislog
extension Analysis {

    @objc(addAnalysislogObject:)
    @NSManaged public func addToAnalysislog(_ value: Log)

    @objc(removeAnalysislogObject:)
    @NSManaged public func removeFromAnalysislog(_ value: Log)

    @objc(addAnalysislog:)
    @NSManaged public func addToAnalysislog(_ values: NSSet)

    @objc(removeAnalysislog:)
    @NSManaged public func removeFromAnalysislog(_ values: NSSet)

}

// MARK: Generated accessors for analysismessages
extension Analysis {

    @objc(addAnalysismessagesObject:)
    @NSManaged public func addToAnalysismessages(_ value: Message)

    @objc(removeAnalysismessagesObject:)
    @NSManaged public func removeFromAnalysismessages(_ value: Message)

    @objc(addAnalysismessages:)
    @NSManaged public func addToAnalysismessages(_ values: NSSet)

    @objc(removeAnalysismessages:)
    @NSManaged public func removeFromAnalysismessages(_ values: NSSet)

}

// MARK: Generated accessors for analysispolls
extension Analysis {

    @objc(addAnalysispollsObject:)
    @NSManaged public func addToAnalysispolls(_ value: Poll)

    @objc(removeAnalysispollsObject:)
    @NSManaged public func removeFromAnalysispolls(_ value: Poll)

    @objc(addAnalysispolls:)
    @NSManaged public func addToAnalysispolls(_ values: NSSet)

    @objc(removeAnalysispolls:)
    @NSManaged public func removeFromAnalysispolls(_ values: NSSet)

}

// MARK: Generated accessors for analysissummary
extension Analysis {

    @objc(addAnalysissummaryObject:)
    @NSManaged public func addToAnalysissummary(_ value: Summary)

    @objc(removeAnalysissummaryObject:)
    @NSManaged public func removeFromAnalysissummary(_ value: Summary)

    @objc(addAnalysissummary:)
    @NSManaged public func addToAnalysissummary(_ values: NSSet)

    @objc(removeAnalysissummary:)
    @NSManaged public func removeFromAnalysissummary(_ values: NSSet)

}

extension Analysis : Identifiable {

}
