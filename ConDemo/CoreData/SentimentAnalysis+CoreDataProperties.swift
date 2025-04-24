//
//  SentimentAnalysis+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/24/25.
//
//

import Foundation
import CoreData


extension SentimentAnalysis {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SentimentAnalysis> {
        return NSFetchRequest<SentimentAnalysis>(entityName: "SentimentAnalysis")
    }

    @NSManaged public var detailanaylsis: DetailedTranscriptAnalysis?
    @NSManaged public var speakerA: SentimentExamples?
    @NSManaged public var speakerB: SentimentExamples?

}

extension SentimentAnalysis : Identifiable {

}
