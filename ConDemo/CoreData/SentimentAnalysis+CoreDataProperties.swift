//
//  SentimentAnalysis+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/23/25.
//
//

import Foundation
import CoreData


extension SentimentAnalysis {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SentimentAnalysis> {
        return NSFetchRequest<SentimentAnalysis>(entityName: "SentimentAnalysis")
    }

    @NSManaged public var speakerA: NSObject?
    @NSManaged public var speakerB: NSObject?
    @NSManaged public var detailanaylsis: DetailedTranscriptAnalysis?
    @NSManaged public var sentimentexample: NSSet?

}

// MARK: Generated accessors for sentimentexample
extension SentimentAnalysis {

    @objc(addSentimentexampleObject:)
    @NSManaged public func addToSentimentexample(_ value: SentimentExamples)

    @objc(removeSentimentexampleObject:)
    @NSManaged public func removeFromSentimentexample(_ value: SentimentExamples)

    @objc(addSentimentexample:)
    @NSManaged public func addToSentimentexample(_ values: NSSet)

    @objc(removeSentimentexample:)
    @NSManaged public func removeFromSentimentexample(_ values: NSSet)

}

extension SentimentAnalysis : Identifiable {

}
