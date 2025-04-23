//
//  CustomStackedBarChartRenderer.swift
//  ConDemo
//
//  Created by 이명지 on 4/23/25.
//

import DGCharts
import UIKit
import Foundation

class CustomStackedBarChartRenderer: HorizontalBarChartRenderer {
    override func drawValues(context: CGContext) {
        guard let dataProvider = dataProvider,
              let barData = dataProvider.barData else { return }
        
        // 원래의 값 그리기 기능 수행
        super.drawValues(context: context)
        
        // 각 스택 영역의 중앙에 'Me'와 'You' 문자 추가
        for i in 0..<dataProvider.data!.dataSets.count {
            guard let dataSet = dataProvider.data!.dataSets[i] as? BarChartDataSet else { continue }
            
            for j in 0..<dataSet.count {
                guard let e = dataSet[j] as? BarChartDataEntry else { continue }
                
                guard let yValues = e.yValues else { continue }
                
                // 바 차트 사각형의 위치와 크기를 직접 계산
                let buffer = barData.dataSets[i].entryForIndex(j)
                
                // X축 값 (수평 바 차트에서는 Y축이 X 값을 나타냄)
                let x = CGFloat(e.x)
                
                // 스택의 시작과 끝 위치 계산
                var yStart: Double = 0.0
                
                for k in 0..<yValues.count {
                    let stackValue = yValues[k]
                    let yEnd = yStart + stackValue
                    
                    // 화면에 변환된 위치 계산 (수평 바 차트이므로 x와 y 반전)
                    let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
                    
                    // 확인해 보니 ChartTransformer 클래스에 pointValueToPixel 메서드가 있을 수 있습니다
                    let startPoint = CGPoint(x: Double(yStart), y: Double(x))
                    let endPoint = CGPoint(x: Double(yEnd), y: Double(x))
                        
                    // 포인트를 픽셀 좌표로 변환
                    var startPointPixels = startPoint
                    var endPointPixels = endPoint
                        
                    trans.pointValueToPixel(&startPointPixels)
                    trans.pointValueToPixel(&endPointPixels)
                        
                    // 바 높이 계산
                    let barHeight = barData.barWidth * viewPortHandler.scaleY
                        
                    let barRect = CGRect(
                        x: startPointPixels.x,
                        y: startPointPixels.y - barHeight / 2,
                        width: endPointPixels.x - startPointPixels.x,
                        height: barHeight
                    )
                    
                    // 레이블 준비
                    let percentValue = k == 0 ? yValues[0] : yValues[1]
                    let label = String(format: "%.0f%%", percentValue)
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 9, weight: .bold),
                        .foregroundColor: UIColor.white,
                        .paragraphStyle: paragraphStyle
                    ]
                    
                    // 스택 영역 중앙에 레이블 그리기
                    let labelSize = (label as NSString).size(withAttributes: attributes)
                    let labelX = barRect.midX - labelSize.width / 2
                    let labelY = barRect.midY - labelSize.height / 2
                    
                    (label as NSString).draw(
                        at: CGPoint(x: labelX, y: labelY),
                        withAttributes: attributes
                    )
                    
                    // 다음 스택의 시작 위치 업데이트
                    yStart = yEnd
                }
            }
        }
    }
}
