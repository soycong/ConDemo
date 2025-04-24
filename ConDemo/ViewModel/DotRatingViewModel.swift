//
//  DotRatingViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/23/25.
//

import UIKit

final class DotRatingViewModel {
    private var consistency: Consistency?
    private var factualAccuracy: FactualAccuracy?
    private let title: String
    private let ratingLabels: [String]
    
    var chartTitle: String { title }
    
    var myRating: Int {
        if title == "주장의 일관성" {
            return consistency?.speakerA.score
        } else {
            return factualAccuracy?.speakerA.score
        }
    }
    
    var yourRating: Int {
        if title == "주장의 일관성" {
            return consistency?.speakerB.score
        } else {
            return factualAccuracy?.speakerB.score
        }
    }
    
    var ratingDescriptions: [String] {
        return ratingLabels
    }
    
    init(title: String, consistency: Consistency? = nil, factualAccuracy: FactualAccuracy? = nil, ratingLabels: [String]) {
        self.title = title
        self.consistency = consistency
        self.factualAccuracy = factualAccuracy
        self.ratingLabels = ratingLabels
    }
}

extension DotRatingViewModel {
    func configure(with consistency: Consistency) {
        self.consistency = consistency
    }
    
    func configure(with factualAccuracy: FactualAccuracy) {
        self.factualAccuracy = factualAccuracy
    }
}
