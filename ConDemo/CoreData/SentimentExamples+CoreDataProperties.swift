//
//  SentimentExamples+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/24/25.
//
//

import Foundation
import CoreData


extension SentimentExamples {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SentimentExamples> {
        return NSFetchRequest<SentimentExamples>(entityName: "SentimentExamples")
    }

    @NSManaged public var negativeExamples: NSObject?
    @NSManaged public var negativeRatio: Double
    @NSManaged public var positiveExamples: NSObject?
    @NSManaged public var positiveRatio: Double
    @NSManaged public var sentimentAnalysisA: SentimentAnalysis?
    @NSManaged public var sentimentAnalysisB: SentimentAnalysis?

}

extension SentimentExamples : Identifiable {

}
