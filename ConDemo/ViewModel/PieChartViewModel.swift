//
//  PieChartViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/23/25.
//

import DGCharts
import UIKit

final class PieChartViewModel {
    private var pieData: SpeakingTime
    
    var chartSubtitle: String { "총 " + String(Int(pieData.speakerA + pieData.speakerB)) + "초"}
    
    var chartEntries: [PieChartDataEntry] {
        return [
            PieChartDataEntry(value: pieData.speakerA, label: "Me"),
            PieChartDataEntry(value: pieData.speakerB, label: "You")
        ]
    }
    
    var chartColors: [UIColor] {
        [
            UIColor(red: 170/255, green: 0/255, blue: 0/255, alpha: 1),
            UIColor(red: 220/255, green: 25/255, blue: 25/255, alpha: 1)
        ]
    }
    
    init(pieData: SpeakingTime) {
        self.pieData = pieData
    }
}
