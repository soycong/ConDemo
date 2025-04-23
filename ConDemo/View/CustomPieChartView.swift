//
//  CustomPieChartView.swift
//  ConDemo
//
//  Created by 이명지 on 4/23/25.
//

import DGCharts
import UIKit

final class CustomPieChartView: UIView {
    private var viewModel: PieChartViewModel?
    
    private let chartTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "말한 시간"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let chartSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 10)
        label.textAlignment = .center
        return label
    }()
    
    private let pieChartView: PieChartView = {
        let chartView = PieChartView()
        
        chartView.chartDescription.enabled = false
        chartView.drawHoleEnabled = false
        chartView.drawEntryLabelsEnabled = false
        chartView.transparentCircleRadiusPercent = 0.6
        
        let legend = chartView.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.xEntrySpace = 7
        legend.yEntrySpace = 0
        
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = UIFont(name: "Pretendard-Regular", size: 10)
        
        chartView.renderer = CustomPieChartRenderer(
            chart: chartView,
            animator: chartView.chartAnimator,
            viewPortHandler: chartView.viewPortHandler
        )
        
        return chartView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSubviews()
        setupConstratins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomPieChartView {
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupSubviews() {
        [
            chartTitleLabel,
            chartSubtitleLabel,
            pieChartView
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstratins() {
        chartTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview().offset(-8)
        }
        
        chartSubtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview().offset(8)
        }
        
        pieChartView.snp.makeConstraints { make in
            make.leading.equalTo(chartTitleLabel.snp.trailing).offset(60)
            make.centerY.equalToSuperview()
            make.size.equalTo(160)
        }
    }
}

extension CustomPieChartView {
    func configure(with viewModel: PieChartViewModel) {
        self.viewModel = viewModel
        updateUI()
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        
        chartSubtitleLabel.text = viewModel.chartSubtitle
        
        let entries = [
            PieChartDataEntry(value: viewModel.chartEntries[0].y, label: "Me"),
            PieChartDataEntry(value: viewModel.chartEntries[1].y, label: "You")
        ]
        
        let dataSet = PieChartDataSet(entries: viewModel.chartEntries, label: "")
        dataSet.colors = viewModel.chartColors
        
        dataSet.sliceSpace = 2
        dataSet.selectionShift = 5
        dataSet.drawIconsEnabled = false
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        formatter.percentSymbol = " %"
        
        let data = PieChartData(dataSet: dataSet)
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueFont(UIFont(name: "Pretendard-Regular", size: 10)!)
        data.setValueTextColor(.black)
        
        pieChartView.data = data
        
        pieChartView.animate(xAxisDuration: 1.0, easingOption: .easeOutBack)
    }
}
