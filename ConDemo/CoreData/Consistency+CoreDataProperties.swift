//
//  Consistency+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/24/25.
//
//

import Foundation
import CoreData


extension Consistency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Consistency> {
        return NSFetchRequest<Consistency>(entityName: "Consistency")
    }

    @NSManaged public var speakerA: SpeakerEvaluation?
    @NSManaged public var detailanaylsis: DetailedTranscriptAnalysis?
    @NSManaged public var speakerB: SpeakerEvaluation?

}

extension Consistency : Identifiable {

}
