//
//  CustomBarChartView.swift
//  ConDemo
//
//  Created by 이명지 on 4/23/25.
//

import DGCharts
import UIKit

final class CustomBarChartView: UIView {
    private let chartTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let meLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BricolageGrotesque-ExtraBold", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let youLabel: UILabel = {
        let label = UILabel()
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
    
}
