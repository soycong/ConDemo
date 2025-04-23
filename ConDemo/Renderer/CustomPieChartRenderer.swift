//
//  CustomPieChartRenderer.swift
//  ConDemo
//
//  Created by 이명지 on 4/23/25.
//

import DGCharts
import UIKit

final class CustomPieChartRenderer: PieChartRenderer {
    override func drawValues(context: CGContext) {
        guard let chart = chart as? PieChartView,
              let data = chart.data else { return }
        
        let center = chart.centerCircleBox
        let radius = chart.radius
        let rotationAngle = chart.rotationAngle
        
        var totalValue: Double = 0.0
        for i in 0..<data.dataSetCount {
            if let dataSet = data.dataSet(at: i) as? PieChartDataSet {
                for entry in dataSet.entries {
                    totalValue += entry.y
                }
            }
        }
        
        var angle: CGFloat = 0.0
        
        for i in 0 ..< data.dataSetCount {
            guard let dataSet = data.dataSet(at: i) as? PieChartDataSet else { continue }
            
            let entries = dataSet.entries
            
            for entry in entries {
                guard let pieEntry = entry as? PieChartDataEntry else { continue }
                
                let sliceAngle = CGFloat(pieEntry.y / totalValue) * 360.0
                let prevAngle = angle
                angle += sliceAngle
                
                let centerAngleRadians = ((prevAngle + sliceAngle / 2.0 + rotationAngle).truncatingRemainder(dividingBy: 360.0)) * .pi / 180.0
                
                let labelRadius = radius * 0.6
                let labelPosition = CGPoint(
                    x: center.x + cos(centerAngleRadians) * labelRadius,
                    y: center.y + sin(centerAngleRadians) * labelRadius
                )
                
                // 1. 화자 레이블
                let speakerLabel = pieEntry.label ?? ""
                
                let speakerAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "BricolageGrotesque-ExtraBold", size: 18)!,
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = .center
                        return paragraphStyle
                    }()
                ]
                
                let speakerSize = (speakerLabel as NSString).size(withAttributes: speakerAttributes)
                
                let speakerRect = CGRect(
                    x: labelPosition.x - speakerSize.width / 2,
                    y: labelPosition.y - speakerSize.height / 2 - 10,
                    width: speakerSize.width,
                    height: speakerSize.height
                )
                
                (speakerLabel as NSString).draw(in: speakerRect, withAttributes: speakerAttributes)
                
                // 2. 시간 레이블 (분) - 작게 표시
                let timeAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "Pretendard-Regular", size: 10)!,
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = .center
                        return paragraphStyle
                    }()
                ]
                
                let minutes = Int(pieEntry.y)
                let timeText = "\(minutes)분"
                let timeSize = (timeText as NSString).size(withAttributes: timeAttributes)
                
                let timeRect = CGRect(
                    x: labelPosition.x - timeSize.width / 2,
                    y: labelPosition.y + speakerSize.height / 2 - 5,
                    width: timeSize.width,
                    height: timeSize.height
                )
                
                (timeText as NSString).draw(in: timeRect, withAttributes: timeAttributes)
            }
        }
    }
}
