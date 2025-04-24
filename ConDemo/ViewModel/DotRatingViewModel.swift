//
//  DotRatingViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/23/25.
//

import UIKit

final class DotRatingViewModel {
    private var consistencyData: ConsistencyData?
    private var factualAccuracyData: FactualAccuracyData?
    private let title: String
    private let ratingLabels: [String]
    
    var chartTitle: String { title }
    
    var myRating: Int {
        if title == "주장의 일관성" {
            return consistencyData?.speakerA.score ?? 0
        } else {
            return factualAccuracyData?.speakerA.score ?? 0
        }
    }
    
    var yourRating: Int {
        if title == "주장의 일관성" {
            return consistencyData?.speakerB.score ?? 0
        } else {
            return factualAccuracyData?.speakerB.score ?? 0
        }
    }
    
    var ratingDescriptions: [String] {
        return ratingLabels
    }
    
    init(title: String, consistencyData: ConsistencyData? = nil, factualAccuracyData: FactualAccuracyData? = nil, ratingLabels: [String]) {
        self.title = title
        self.consistencyData = consistencyData
        self.factualAccuracyData = factualAccuracyData
        self.ratingLabels = ratingLabels
    }
}

extension DotRatingViewModel {
    func configure(with consistencyData: ConsistencyData) {
        self.consistencyData = consistencyData
    }
    
    func configure(with factualAccuracyData: FactualAccuracyData) {
        self.factualAccuracyData = factualAccuracyData
    }
}
