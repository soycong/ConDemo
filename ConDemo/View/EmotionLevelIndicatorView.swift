//
//  EmotionLevelIndicatorView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/14/25.
//

import UIKit
import SnapKit

final class EmotionLevelIndicatorView: UIView {
    
//    enum EmotionLevel: Int {
//        case low
//        case medium
//        case high
//    }
    
    private var emotionIcons = ["🙃", "😕", "😨", "😵‍💫", "😤", "🤯", "😵‍💫", "😡", "🤬", "🤪"]
    
    private var barView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor.yellow.cgColor, UIColor.orange.cgColor, UIColor.red.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        return gradientLayer
    }()
    
    private let markerView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let emotionLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    var emotionLevel: Int = 10 {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = barView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = barView.bounds
        }
        
        updateMarkerPosition()
    }
    
    private func configureUI() {
        addSubview(barView)
        barView.layer.insertSublayer(gradientLayer, at: 0)
        addSubview(markerView)
        addSubview(emotionLabel)

        barView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(16)
        }
        
        markerView.snp.makeConstraints { make in
            make.top.equalTo(barView.snp.bottom).offset(2)
            make.height.width.equalTo(16)
        }
        
        emotionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(markerView.snp.bottom).offset(8)
            make.bottom.centerX.equalToSuperview()
        }
        
        updateUI()
    }
    
    private func updateUI() {
        switch emotionLevel {
        case 1...5:
            emotionLabel.text = "순한맛 \(emotionLevel)단계 \(emotionIcons[emotionLevel - 1])"
        case 6...10:
            emotionLabel.text = "매운맛 \(emotionLevel)단계 \(emotionIcons[emotionLevel - 1])"
        default:
            emotionLabel.text = "분석이 어렵습니다."
        }
        
        updateMarkerPosition()
    }
    
    private func updateMarkerPosition() {
        let percentage = CGFloat(emotionLevel) / 10.0
        let barWidth = barView.bounds.width
        
        // 기존 제약조건 찾기
        if let constraint = constraints.first(where: {
            ($0.firstItem === markerView && $0.firstAttribute == .centerX) ||
            ($0.secondItem === markerView && $0.secondAttribute == .centerX)
        }) {
            // 기존 제약조건 제거
            removeConstraint(constraint)
        }
        
        // 위치에 맞게 새 제약조건 추가
        let xPosition = barView.frame.origin.x + (barWidth * percentage)
        let constraint = NSLayoutConstraint(
            item: markerView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: xPosition
        )
        addConstraint(constraint)
        
        // 즉시 레이아웃 업데이트
        setNeedsLayout()
    }
}
