//
//  CustomBarChartView.swift
//  ConDemo
//
//  Created by 이명지 on 4/23/25.
//

import DGCharts
import UIKit

final class CustomBarChartView: UIView {
    private var viewModel: BarChartViewModel?
    
    private let chartTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textAlignment = .left
        return label
    }()
    
    private let meLabel: UILabel = {
        let label = UILabel()
        label.text = "Me"
        label.font = UIFont(name: "BricolageGrotesque-ExtraBold", size: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let youLabel: UILabel = {
        let label = UILabel()
        label.text = "You"
        label.font = UIFont(name: "BricolageGrotesque-ExtraBold", size: 18)
        label.textAlignment = .right
        return label
    }()
    
    private let barChartView: HorizontalBarChartView = {
        let chartView = HorizontalBarChartView()
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.legend.enabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.gridBackgroundColor = .clear
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.chartDescription.enabled = false
        chartView.drawBarShadowEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.isUserInteractionEnabled = false
        return chartView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomBarChartView {
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupSubviews() {
        [
            chartTitleLabel,
            meLabel,
            youLabel,
            barChartView
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        chartTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        barChartView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(60)
        }
        
        meLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(barChartView.snp.top).offset(-4)
        }
        
        youLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(barChartView.snp.top).offset(-4)
        }
    }
}

extension CustomBarChartView {
    func configure(with viewModel: BarChartViewModel) {
        self.viewModel = viewModel
        updateUI()
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        
        chartTitleLabel.text = viewModel.chartTitle
        
        updateChartData()
    }
    
    private func updateChartData() {
        guard let viewModel = viewModel else { return }
        
        // 스택 차트를 위해 단일 Entry 생성
        let barEntry = BarChartDataEntry(x: 0, yValues: getYValues(viewModel))
        
        // 스택 차트 데이터셋 생성
        let dataSet = BarChartDataSet(entries: [barEntry], label: "")
        dataSet.colors = [viewModel.myColor, viewModel.yourColor] // 각 스택의 색상 설정
        dataSet.stackLabels = ["Me", "You"] // 스택 라벨 설정
        dataSet.drawValuesEnabled = false
        dataSet.valueFormatter = StackedPercentFormatter(
            meValue: getMeValue(viewModel),
            youValue: getYouValue(viewModel)
        )
        
        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.75
        
        data.setValueFont(UIFont.systemFont(ofSize: 12, weight: .bold))
        data.setValueTextColor(.black)
        
        barChartView.data = data
        
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.axisMaximum = 100
        
        // 차트 렌더러 커스터마이징
        barChartView.renderer = CustomStackedBarChartRenderer(
            dataProvider: barChartView,
            animator: barChartView.chartAnimator,
            viewPortHandler: barChartView.viewPortHandler
        )
        
        barChartView.notifyDataSetChanged()
        barChartView.animate(yAxisDuration: 1.0)
    }
    
    private func getYValues(_ viewModel: BarChartViewModel) -> [Double] {
        if viewModel.isPositive {
            return [
                viewModel.myValue.positiveRatio * 100,
                viewModel.yourValue.positiveRatio * 100
            ]
        } else {
            return [
                viewModel.myValue.negativeRatio * 100,
                viewModel.yourValue.negativeRatio * 100
            ]
        }
    }
    
    private func getMeValue(_ viewModel: BarChartViewModel) -> Double {
        if viewModel.isPositive {
            return viewModel.myValue.positiveRatio * 100
        } else {
            return viewModel.myValue.negativeRatio * 100
        }
    }
    
    private func getYouValue(_ viewModel: BarChartViewModel) -> Double {
        if viewModel.isPositive {
            return viewModel.yourValue.positiveRatio * 100
        } else {
            return viewModel.yourValue.negativeRatio * 100
        }
    }
}

class StackedPercentFormatter: ValueFormatter {
    private let meValue: Double
    private let youValue: Double
    
    init(meValue: Double, youValue: Double) {
        self.meValue = meValue
        self.youValue = youValue
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        guard let barEntry = entry as? BarChartDataEntry else { return "" }
        
        // 스택 구성요소 인덱스를 확인하기 위한 데이터 구조
        let stackIndex = dataSetIndex
        
        if stackIndex == 0 {
            // Me 영역
            return String(format: "%.0f%%", meValue)
        } else {
            // You 영역
            return String(format: "%.0f%%", youValue)
        }
    }
}
