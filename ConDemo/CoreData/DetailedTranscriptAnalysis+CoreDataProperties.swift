//
//  DetailedTranscriptAnalysis+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/24/25.
//
//

import Foundation
import CoreData


extension DetailedTranscriptAnalysis {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DetailedTranscriptAnalysis> {
        return NSFetchRequest<DetailedTranscriptAnalysis>(entityName: "DetailedTranscriptAnalysis")
    }

    @NSManaged public var date: Date?
    @NSManaged public var analysis: Analysis?
    @NSManaged public var speakingTime: SpeakingTime?
    @NSManaged public var consistency: Consistency?
    @NSManaged public var factualAccuracy: FactualAccuracy?
    @NSManaged public var sentimentAnalysis: SentimentAnalysis?

}

extension DetailedTranscriptAnalysis : Identifiable {

}
