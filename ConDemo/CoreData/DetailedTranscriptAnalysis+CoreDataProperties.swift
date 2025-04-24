//
//  DetailedTranscriptAnalysis+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/23/25.
//
//

import Foundation
import CoreData


extension DetailedTranscriptAnalysis {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DetailedTranscriptAnalysis> {
        return NSFetchRequest<DetailedTranscriptAnalysis>(entityName: "DetailedTranscriptAnalysis")
    }

    @NSManaged public var speakingTime: NSObject?
    @NSManaged public var overlaps: NSObject?
    @NSManaged public var overlapTopics: NSObject?
    @NSManaged public var consistency: NSObject?
    @NSManaged public var factualAccuracy: NSObject?
    @NSManaged public var sentimentAnalysis: NSObject?
    @NSManaged public var incorrectUsage: NSObject?
    @NSManaged public var date: Date?
    @NSManaged public var analysis: Analysis?
    @NSManaged public var detailspeakingtime: SpeakingTime?
    @NSManaged public var detailoverlaps: Overlaps?
    @NSManaged public var detailconsistency: Consistency?
    @NSManaged public var detailfactualaccuracy: FactualAccuracy?
    @NSManaged public var detailsentimentanalysis: SentimentAnalysis?
    @NSManaged public var detailincorrectusage: IncorrectUsage?

}

extension DetailedTranscriptAnalysis : Identifiable {

}
