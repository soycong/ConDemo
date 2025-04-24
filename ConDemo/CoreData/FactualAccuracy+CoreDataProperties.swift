//
//  FactualAccuracy+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/24/25.
//
//

import Foundation
import CoreData


extension FactualAccuracy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FactualAccuracy> {
        return NSFetchRequest<FactualAccuracy>(entityName: "FactualAccuracy")
    }

    @NSManaged public var detailanaylsis: DetailedTranscriptAnalysis?
    @NSManaged public var speakerA: SpeakerEvaluation?
    @NSManaged public var speakerB: SpeakerEvaluation?

}

extension FactualAccuracy : Identifiable {

}
