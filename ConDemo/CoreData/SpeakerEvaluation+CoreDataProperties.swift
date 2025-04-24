//
//  SpeakerEvaluation+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/23/25.
//
//

import Foundation
import CoreData


extension SpeakerEvaluation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpeakerEvaluation> {
        return NSFetchRequest<SpeakerEvaluation>(entityName: "SpeakerEvaluation")
    }

    @NSManaged public var score: Int64
    @NSManaged public var reasoning: String?
    @NSManaged public var factual: FactualAccuracy?
    @NSManaged public var consistency: Consistency?

}

extension SpeakerEvaluation : Identifiable {

}
