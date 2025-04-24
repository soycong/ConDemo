//
//  FactualAccuracy+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/23/25.
//
//

import Foundation
import CoreData


extension FactualAccuracy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FactualAccuracy> {
        return NSFetchRequest<FactualAccuracy>(entityName: "FactualAccuracy")
    }

    @NSManaged public var speakerA: NSObject?
    @NSManaged public var speakerB: NSObject?
    @NSManaged public var detailanaylsis: DetailedTranscriptAnalysis?
    @NSManaged public var factualevaluation: SpeakerEvaluation?

}

extension FactualAccuracy : Identifiable {

}
