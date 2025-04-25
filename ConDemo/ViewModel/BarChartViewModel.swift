//
//  BarChartViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/23/25.
//

import DGCharts
import UIKit

final class BarChartViewModel {
    private var barData: SentimentAnalysis
    private let title: String
    let isPositive: Bool
    
    var chartTitle: String { title }
    
    var myValue: SentimentExamples { barData.speakerA as! SentimentExamples }
    
    var yourValue: SentimentExamples { barData.speakerB as! SentimentExamples }

    var myColor: UIColor { UIColor(red: 170/255, green: 0/255, blue: 0/255, alpha: 1) }
    
    var yourColor: UIColor { UIColor(red: 220/255, green: 25/255, blue: 25/255, alpha: 1) }
    
    init(barData: SentimentAnalysis, title: String, isPositive: Bool) {
        self.barData = barData
        self.title = title
        self.isPositive = isPositive
    }
}

extension BarChartViewModel {
    func updateData(_ barData: SentimentAnalysis) {
        self.barData = barData
    }
}
