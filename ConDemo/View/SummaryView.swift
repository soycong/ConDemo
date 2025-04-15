//
//  SummaryView.swift
//  ConDemo
//
//  Created by 이명지 on 4/11/25.
//

import UIKit

final class SummaryView: UIView {
    // MARK: - Properties

    private(set) lazy var summaryStackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [firstSummaryLabel,
                                                              secondSummaryLabel,
                                                              thirdSummaryLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

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

    private var firstSummaryLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private var secondSummaryLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private var thirdSummaryLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textAlignment = .left
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

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupSubviews()
        setupConstraints()
        setupButtonTags()
        setupADimage()
        setupTestText()
    }

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
         summaryStackView,
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

        summaryStackView.snp.makeConstraints { make in
            make.top.equalTo(summaryDateLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(25)
        }

        emotionLevelIndicator.snp.makeConstraints { make in
            make.top.equalTo(summaryStackView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(13)
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

    private func setupTestText() {
        summaryTitleLabel.text = "허락 없는 도움, 오해와 화해 사이"
        summaryDateLabel.text = "2025.04.07 오후 20:20 | 205min 47sec"

        firstSummaryLabel
            .text = "1. 허락 없이 파일 수정한 행위 - 허락 없이 프로젝트 자료를 수정하여 충돌이 발생했습니다. 기본적인 매너와 소통의 문제가 제기되었습니다."
        secondSummaryLabel.text = "2. 프로젝트 마감 시간에 대한 오해 - 프로젝트 마감이 오늘이라는 사실이 뒤늦게 밝혀져 급박한 상황이 되었습니다."
        thirdSummaryLabel
            .text =
            "3. 도움의 의도와 인식 차이 - 한 사람은 도움을 주려 했다고 생각했지만, 다른 사람은 이를 원치 않는 간섭으로 받아들여 감정적 대립이 일어났습니다"

        [firstSummaryLabel,
         secondSummaryLabel,
         thirdSummaryLabel].forEach {
            $0.attributedText = setupParagraphStyle(text: $0.text ?? "")
        }
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
