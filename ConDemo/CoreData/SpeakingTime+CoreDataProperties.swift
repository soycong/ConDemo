//
//  SpeakingTime+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/23/25.
//
//

import Foundation
import CoreData


extension SpeakingTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpeakingTime> {
        return NSFetchRequest<SpeakingTime>(entityName: "SpeakingTime")
    }

    @NSManaged public var speakerA: Double
    @NSManaged public var speakerB: Double
    @NSManaged public var detailanaylsis: DetailedTranscriptAnalysis?

}

extension SpeakingTime : Identifiable {

}
