//
//  EmotionLevelIndicatorView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/14/25.
//

import SnapKit
import UIKit

final class EmotionLevelIndicatorView: UIView {
    // MARK: - Properties

    var emotionLevel: Int = 10 {
        didSet {
            updateUI()
        }
    }

//    enum EmotionLevel: Int {
//        case low
//        case medium
//        case high
//    }

    private var emotionIcons = ["🙃", "😕", "😨", "😵‍💫", "😤", "🤯", "😵‍💫", "😡", "🤬", "🤪"]

    private var barView: UIView = {
        let view: UIView = .init()

        view.layer.cornerRadius = 5

        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = 1

        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private var gradientLayer: CAGradientLayer = {
        let gradientLayer: CAGradientLayer = .init()

        gradientLayer.colors = [UIColor.emotionLowYellow.cgColor, UIColor.emotionMidRed.cgColor,
                                UIColor.emotionHighRed.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        return gradientLayer
    }()

    private let markerView: UIImageView = {
        let imageView: UIImageView = .init()

        imageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let emotionLabel: UILabel = {
        let label: UILabel = .init()

        label.font = UIFont(name: "Pretendard-ExtraBold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left

        return label
    }()

    // MARK: - Lifecycle

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

    // MARK: - Functions

    private func configureUI() {
        addSubview(barView)
        barView.layer.insertSublayer(gradientLayer, at: 0)
        addSubview(markerView)
        addSubview(emotionLabel)

        barView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(11)
        }

        markerView.snp.makeConstraints { make in
            make.top.equalTo(barView.snp.bottom).offset(6)
            make.height.width.equalTo(16)
        }

        emotionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(markerView.snp.bottom).offset(10)
            make.bottom.centerX.equalToSuperview()
        }

        updateUI()
    }

    private func updateUI() {
        switch emotionLevel {
        case 0 ... 1:
            emotionLabel.text = "순한맛 \(1)단계 \(emotionIcons[0])"
        case 2 ... 5:
            emotionLabel.text = "순한맛 \(emotionLevel)단계 \(emotionIcons[emotionLevel - 1])"
        case 6 ... 10:
            emotionLabel.text = "매운맛 \(emotionLevel)단계 \(emotionIcons[emotionLevel - 1])"
        default:
            emotionLabel.text = "분석이 어렵습니다. Level: \(emotionLevel)"
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
        let constraint: NSLayoutConstraint = .init(item: markerView,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .leading,
                                                   multiplier: 1.0,
                                                   constant: xPosition)
        addConstraint(constraint)

        // 즉시 레이아웃 업데이트
        setNeedsLayout()
    }
}
