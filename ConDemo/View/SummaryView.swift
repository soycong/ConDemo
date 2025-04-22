//
//  SummaryView.swift
//  ConDemo
//
//  Created by 이명지 on 4/11/25.
//
//
import UIKit

final class SummaryView: UIScrollView {
    // MARK: - Properties

    private(set) var factCheckButton: AnalysisButton = .init(iconName: ButtonSystemIcon.aiIcon,
                                                             title: "AI와 팩트 체크하기")
    private(set) var logButton: AnalysisButton = .init(iconName: ButtonSystemIcon.logIcon,
                                                       title: "싸움 로그 보기")
    private(set) var pollButton: AnalysisButton = .init(iconName: ButtonSystemIcon.pollIcon,
                                                        title: "자동 Poll 생성하기")
    private(set) var summaryButton: AnalysisButton = .init(iconName: ButtonSystemIcon.summaryIcon,
                                                           title: "요약 버전 생성하기")

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .baseBackground
        return view
    }()
    
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
    
    // 페이지 컨트롤
    private(set) var pageControl: UIPageControl = {
        let control = UIPageControl()
        
        control.translatesAutoresizingMaskIntoConstraints = false
        control.currentPageIndicatorTintColor = .pointBlue
        control.pageIndicatorTintColor = .lightGray
        control.isHidden = true // 기본적으로 숨겨둠 (데이터가 1개일 때)
        
        return control
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
    
    // 스와이프 제스처 인식
    private(set) var leftSwipeGestureRecognizer: UISwipeGestureRecognizer!
    private(set) var rightSwipeGestureRecognizer: UISwipeGestureRecognizer!
    
    init() {
        super.init(frame: .zero)
        
        setupScrollView()
        setupView()
        setupSubviews()
        setupConstraints()
        setupButtonTags()
        setupADimage()
        setupSwipeGestures()
    }

    // MARK: - Lifecycle

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SummaryView {
    private func setupScrollView() {
        self.backgroundColor = .baseBackground
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.alwaysBounceVertical = true
        
        self.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self)
        }
    }
    
    private func setupView() {
        contentView.backgroundColor = .baseBackground
    }
    
    private func setupSubviews() {
        [adBanner,
         summaryTitleLabel,
         summaryDateLabel,
         summaryLabel,
         analysisLabel,
         emotionLevelIndicator,
         buttonStackView,
         pageControl].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        adBanner.snp.makeConstraints { make in
            make.top.equalToSuperview()
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
            make.horizontalEdges.equalToSuperview().inset(25)
        }
        
        emotionLevelIndicator.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(25)
        }
        
        analysisLabel.snp.makeConstraints { make in
            make.top.equalTo(emotionLevelIndicator.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(25)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(analysisLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
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
            make.top.equalTo(analysisLabel.snp.bottom).offset(37)
            make.horizontalEdges.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().offset(-20)
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
    
    private func setupSwipeGestures() {
        // 왼쪽 스와이프 (다음 페이지로)
        leftSwipeGestureRecognizer = UISwipeGestureRecognizer()
        leftSwipeGestureRecognizer.direction = .left
        addGestureRecognizer(leftSwipeGestureRecognizer)
        
        // 오른쪽 스와이프 (이전 페이지로)
        rightSwipeGestureRecognizer = UISwipeGestureRecognizer()
        rightSwipeGestureRecognizer.direction = .right
        addGestureRecognizer(rightSwipeGestureRecognizer)
    }
    
    func setupText(analysis: Analysis) {
        summaryTitleLabel.text = analysis.title?.replacingOccurrences(of: "\"", with: "") ?? "제목 없음"
        
        // 날짜 설정
        if let date = analysis.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd a HH:mm"
            formatter.locale = Locale(identifier: "ko_KR")
            summaryDateLabel.text = formatter.string(from: date)
        } else {
            summaryDateLabel.text = "날짜 정보 없음"
        }
        
        // 내용 설정 - 줄바꿈 보존
        if let contents = analysis.contents {
            summaryLabel.attributedText = setupParagraphStyle(text: contents)
            
            // 내용 길이에 따라 label 높이 자동 조정을 위해 고정 높이 제약 제거
            summaryLabel.snp.remakeConstraints { make in
                make.top.equalTo(summaryDateLabel.snp.bottom).offset(24)
                make.horizontalEdges.equalToSuperview().inset(25)
            }
        } else {
            summaryLabel.text = "내용 없음"
        }
        
        // 감정 레벨 설정
        emotionLevelIndicator.emotionLevel = Int(analysis.level)
        
        // 레이아웃 업데이트 호출
        self.layoutIfNeeded()
    }
    
    // 페이지 컨트롤 설정
    func setupPageControl(totalPages: Int, currentPage: Int) {
        pageControl.numberOfPages = totalPages
        pageControl.currentPage = currentPage
        pageControl.isHidden = totalPages <= 1
    }
    
    private func setupParagraphStyle(text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10.0
        paragraphStyle.paragraphSpacing = 8.0 // 문단 사이 간격 추가
        
        // 줄바꿈 보존
        let cleanText = text.replacingOccurrences(of: "\"", with: "")
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.label
        ]
        
        return NSAttributedString(string: cleanText, attributes: attributes)
    }
    
    // 페이지 전환 애니메이션
    func animatePageTransition(direction: UIView.AnimationOptions, completion: @escaping () -> Void) {
        UIView.transition(with: self, duration: 0.3, options: direction, animations: {
            // 애니메이션 자체는 빈 클로저로 처리하고 완료 후 콜백 실행
        }, completion: { _ in
            completion()
        })
    }
}
