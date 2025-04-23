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
        label.textAlignment = .center
        return label
    }()
    
    private let meLabel: UILabel = {
        let label = UILabel()
        label.text = "Me"
        label.font = UIFont(name: "BricolageGrotesque-ExtraBold", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let youLabel: UILabel = {
        let label = UILabel()
        label.text = "You"
        label.font = UIFont(name: "BricolageGrotesque-ExtraBold", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let barChartView: HorizontalBarChartView = {
        let chartView = HorizontalBarChartView()
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.legend.enabled = false
        chartView.drawValueAboveBarEnabled = true
        chartView.gridBackgroundColor = .clear
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.chartDescription.enabled = false
        chartView.drawBarShadowEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
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
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        barChartView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
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
        
        var myEntry: BarChartDataEntry
        var yourEntry: BarChartDataEntry
        
        if viewModel.isPositive {
            myEntry = BarChartDataEntry(x: 1, y: viewModel.myValue.positiveRatio)
            yourEntry = BarChartDataEntry(x: 0, y: viewModel.yourValue.positiveRatio)
        } else {
            myEntry = BarChartDataEntry(x: 1, y: viewModel.myValue.negativeRatio)
            yourEntry = BarChartDataEntry(x: 0, y: viewModel.yourValue.negativeRatio)
        }
        
        let myDataSet = BarChartDataSet(entries: [myEntry], label: "Me")
        myDataSet.setColor(viewModel.myColor)
        myDataSet.drawValuesEnabled = true
        
        let yourDataSet = BarChartDataSet(entries: [yourEntry], label: "You")
        yourDataSet.setColor(viewModel.yourColor)
        yourDataSet.drawValuesEnabled = true
        
        let data = BarChartData(dataSets: [myDataSet, yourDataSet])
        data.barWidth = 0.5
        
        barChartView.data = data
        
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.axisMaximum = 100
        
        barChartView.notifyDataSetChanged()
        barChartView.animate(yAxisDuration: 1.0)
    }
}
