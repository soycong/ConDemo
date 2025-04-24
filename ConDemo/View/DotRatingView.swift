//
//  DotRatingView.swift
//  ConDemo
//
//  Created by 이명지 on 4/23/25.
//

import UIKit

final class DotRatingView: UIView {
    private var viewModel: DotRatingViewModel?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textAlignment = .left
        return label
    }()
    
    private let myLabel: UILabel = {
        let label = UILabel()
        label.text = "Me"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let yourLabel: UILabel = {
        let label = UILabel()
        label.text = "You"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    // dot chart 그릴 컨테이너 뷰
    private let myRatingView = UIView()
    private let yourRatingView = UIView()
    
    private var ratingLabels: [UILabel] = []
    
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

extension DotRatingView {
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupSubviews() {
        [
            titleLabel,
            myLabel,
            yourLabel,
            myRatingView,
            yourRatingView
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        myLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalTo(40)
        }
        
        myRatingView.snp.makeConstraints { make in
            make.leading.equalTo(myLabel.snp.trailing).offset(15)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(myLabel)
            make.height.equalTo(40)
        }
        
        yourLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(myLabel.snp.bottom).offset(30)
            make.width.equalTo(40)
        }
        
        yourRatingView.snp.makeConstraints { make in
            make.leading.equalTo(yourLabel.snp.trailing).offset(15)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(yourLabel)
            make.height.equalTo(40)
        }
    }
}

extension DotRatingView {
    private func createRatingUI(in containerView: UIView, rating: Int, labels: [String]) {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        let containerWidth = containerView.bounds.width
        let itemWidth = containerWidth / CGFloat(5) // 5개 아이템
        
        var labelViews: [UILabel] = []
        for i in 0..<5 {
            let label = UILabel()
            label.text = labels[i]
            label.font = UIFont.systemFont(ofSize: 10)
            label.textAlignment = .center
            label.textColor = .darkGray
            containerView.addSubview(label)
            
            label.snp.makeConstraints { make in
                make.centerX.equalTo(containerView.snp.leading).offset(itemWidth * CGFloat(i) + itemWidth/2)
                make.bottom.equalTo(containerView)
                make.width.equalTo(itemWidth)
            }
            
            labelViews.append(label)
        }
        
        // 원, 라인 생성
        var circleViews: [UIView] = []
        for i in 0..<5 {
            let circleView = UIView()
            circleView.backgroundColor = i == rating - 1 ? UIColor.red : UIColor.white
            circleView.layer.borderColor = UIColor.gray.cgColor
            circleView.layer.borderWidth = 1
            circleView.layer.cornerRadius = 8
            containerView.addSubview(circleView)
            
            circleView.snp.makeConstraints { make in
                make.centerX.equalTo(containerView.snp.leading).offset(itemWidth * CGFloat(i) + itemWidth/2)
                make.top.equalTo(containerView).offset(5)
                make.width.height.equalTo(16)
            }
            
            circleViews.append(circleView)
            
            // 첫 번째 원이 아니면 이전 원과 연결하는 선 추가
            if i > 0 {
                let previousCircle = circleViews[i-1]
                let lineView = UIView()
                lineView.backgroundColor = UIColor.gray
                containerView.addSubview(lineView)
                containerView.sendSubviewToBack(lineView) // 선을 원 뒤로 보내기
                
                lineView.snp.makeConstraints { make in
                    make.centerY.equalTo(circleView)
                    make.leading.equalTo(previousCircle.snp.centerX)
                    make.trailing.equalTo(circleView.snp.centerX)
                    make.height.equalTo(1)
                }
            }
        }
    }
    
    // 뷰 업데이트
    func configure(with viewModel: DotRatingViewModel) {
        self.viewModel = viewModel
        updateUI()
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.chartTitle
        
        // 레이아웃이 이미 적용된 후에 dot chart 생성
        DispatchQueue.main.async {
            self.createRatingUI(
                in: self.myRatingView,
                rating: viewModel.myRating,
                labels: viewModel.ratingDescriptions
            )
            
            self.createRatingUI(
                in: self.yourRatingView,
                rating: viewModel.yourRating,
                labels: viewModel.ratingDescriptions
            )
        }
    }
}

