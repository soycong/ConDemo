//
//  SpeakerEvaluation+CoreDataProperties.swift
//  ConDemo
//
//  Created by seohuibaek on 4/24/25.
//
//

import Foundation
import CoreData


extension SpeakerEvaluation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpeakerEvaluation> {
        return NSFetchRequest<SpeakerEvaluation>(entityName: "SpeakerEvaluation")
    }

    @NSManaged public var reasoning: String?
    @NSManaged public var score: Int64
    @NSManaged public var consistencyA: Consistency?
    @NSManaged public var factualA: FactualAccuracy?
    @NSManaged public var consistencyB: Consistency?
    @NSManaged public var factualB: FactualAccuracy?

}

extension SpeakerEvaluation : Identifiable {

}
