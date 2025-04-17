//
//  SummaryView.swift
//  ConDemo
//
//  Created by 이명지 on 4/11/25.
//

import UIKit

final class SummaryView: UIView {
    // MARK: - Properties

    private(set) var factCheckButton: AnalysisButton = .init(iconName: ButtonSystemIcon.aiIcon,
                                                             title: "AI와 팩트 체크하기")
    private(set) var logButton: AnalysisButton = .init(iconName: ButtonSystemIcon.logIcon,
                                                       title: "싸움 로그 보기")
    private(set) var pollButton: AnalysisButton = .init(iconName: ButtonSystemIcon.pollIcon,
                                                        title: "자동 Poll 생성하기")
    private(set) var summaryButton: AnalysisButton = .init(iconName: ButtonSystemIcon.summaryIcon,
                                                           title: "요약 버전 생성하기")

    private var adBanner: UIImageView = {
        let view: UIImageView = .init()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 14
        view.backgroundColor = .beigeGray
        return view
    }()

    private var summaryTitleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = UIFont(name: "Pretendard-ExtraBold", size: 26)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()

    private var summaryDateLabel: UILabel = {
        let label: UILabel = .init()
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()

    private var summaryLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()

    private let analysisLabel: UILabel = {
        let label: UILabel = .init()
        label.font = UIFont(name: "BricolageGrotesque-Bold", size: 26)
        label.text = "Analysis"
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()

    private let emotionLevelIndicator: EmotionLevelIndicatorView = {
        let view: EmotionLevelIndicatorView = .init()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.emotionLevel = 9

        return view
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [factCheckButton,
                                                              logButton,
                                                              pollButton,
                                                              summaryButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        setupSubviews()
        setupConstraints()
        setupButtonTags()
        setupADimage()
    }

    // MARK: - Lifecycle

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SummaryView {
    private func setupView() {
        backgroundColor = .baseBackground
    }

    private func setupSubviews() {
        [adBanner,
         summaryTitleLabel,
         summaryDateLabel,
         summaryLabel,
         buttonStackView,
         analysisLabel,
         emotionLevelIndicator,
         buttonStackView].forEach {
            addSubview($0)
        }
    }

    private func setupConstraints() {
        adBanner.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(96)
            make.horizontalEdges.equalToSuperview().inset(13)
            make.height.equalTo(72)
        }

        summaryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(adBanner.snp.bottom).offset(31)
            make.horizontalEdges.equalToSuperview().inset(25)
        }

        summaryDateLabel.snp.makeConstraints { make in
            make.top.equalTo(summaryTitleLabel.snp.bottom).offset(17)
            make.horizontalEdges.equalToSuperview().inset(25)
        }

        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(summaryDateLabel.snp.bottom).offset(24)
            make.height.equalTo(150)
            make.horizontalEdges.equalToSuperview().inset(25)
        }

        emotionLevelIndicator.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(25)
            // make.height.equalTo(60)
        }

        analysisLabel.snp.makeConstraints { make in
            make.top.equalTo(emotionLevelIndicator.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(25)
        }

        [factCheckButton,
         logButton,
         pollButton,
         summaryButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(analysisLabel.snp.bottom).offset(17)
            make.horizontalEdges.equalToSuperview().inset(25)
        }
    }

    private func setupButtonTags() {
        factCheckButton.tag = 1
        logButton.tag = 2
        pollButton.tag = 3
        summaryButton.tag = 4
    }

    private func setupADimage() {
        adBanner.image = UIImage(named: "landingAD")
    }

    func setupText(analysis: Analysis) {
        summaryTitleLabel.text = analysis.title ?? "제목 없음"
        
        // 날짜 설정
        if let date = analysis.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd a HH:mm"
            formatter.locale = Locale(identifier: "ko_KR")
            summaryDateLabel.text = formatter.string(from: date)
        } else {
            summaryDateLabel.text = "날짜 정보 없음"
        }

        summaryLabel
            .text = analysis.contents?.description
        summaryLabel.attributedText = setupParagraphStyle(text: summaryLabel.text ?? "")
        
        // 감정 레벨 설정
        emotionLevelIndicator.emotionLevel = Int(analysis.level)
    }
}

extension SummaryView {
    private func setupParagraphStyle(text: String) -> NSAttributedString {
        let paragraphStyle: NSMutableParagraphStyle = .init()
        paragraphStyle.lineSpacing = 10.0

        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle,
                                                         .font: UIFont(name: "Pretendard-Medium",
                                                                       size: 12),
                                                         .foregroundColor: UIColor.label]

        return NSAttributedString(string: text, attributes: attributes)
    }
}

