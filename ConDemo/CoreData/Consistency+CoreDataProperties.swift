//
//  Consistency+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/23/25.
//
//

import Foundation
import CoreData


extension Consistency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Consistency> {
        return NSFetchRequest<Consistency>(entityName: "Consistency")
    }

    @NSManaged public var speakerA: NSObject?
    @NSManaged public var speakerB: NSObject?
    @NSManaged public var detailanaylsis: DetailedTranscriptAnalysis?
    @NSManaged public var consistencyevaluation: SpeakerEvaluation?

}

extension Consistency : Identifiable {

}
