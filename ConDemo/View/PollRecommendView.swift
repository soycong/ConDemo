//
//  PollRecommendView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/10/25.
//

import UIKit

final class PollRecommendView: UIView {
    // MARK: - Properties

    private(set) var confirmButton: UIButton = {
        let button: UIButton = .init()

        button.setTitle("Posting", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)

        button.backgroundColor = .gray
        button.layer.cornerRadius = 4

        return button
    }()

    private let placeholderText = "내용을 입력해주세요."
    private var isPosted = false
    private var currentPage = 0

    private var pollContents: [PollContent] = [PollContent.defaultTemplate(),
                                               PollContent.defaultTemplate(),
                                               PollContent.defaultTemplate()]

    private let titleLabel: UILabel = {
        let label: UILabel = .init()

        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Poll 추천"

        return label
    }()

    private let dateLabel: UILabel = {
        let label: UILabel = .init()

        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "2025.04.10 오후 17:00"

        return label
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()

    private let pageControl: UIPageControl = {
        let pageControl: UIPageControl = .init()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        return pageControl
    }()

    private var textViews: [UITextView] = []

    private lazy var titleStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [titleLabel, confirmButton])

        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill

        return stackView
    }()

    private lazy var contentStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [titleStackView, dateLabel])

        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill

        return stackView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        configureUI()
        setupTextViews()
        setupActions()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        scrollView.contentSize = CGSize(width: scrollView.frame.width * 3,
                                        height: scrollView.frame.height)

        for (index, textView) in textViews.enumerated() {
            textView.frame = CGRect(x: scrollView.frame.width * CGFloat(index),
                                    y: 0,
                                    width: scrollView.frame.width,
                                    height: scrollView.frame.height)
        }
    }

    // MARK: - Functions

    // 현재 TextView에서 Poll 데이터 추출
//    private func extractPollDataFromCurrentTextView() {
//        let textView = textViews[currentPage]
//        print("현재 페이지 \(currentPage+1)의 Poll 데이터 추출")
//    }

    /// 모든 TextView의 텍스트 내용 가져오기
    func getAllTextContents() -> [String] {
        textViews.map(\.text)
    }

    private func configureUI() {
        addSubview(contentStackView)
        addSubview(scrollView)
        addSubview(pageControl)

        contentStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }

        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }

        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(80)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(pageControl.snp.top).offset(-10)
        }

        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
    }

    private func setupTextViews() {
        for i in 0 ..< 3 { // TextView 3개
            let textView: UITextView = .init()
            textView.layer.cornerRadius = 10
            textView.backgroundColor = .backgroundGray
            textView.delegate = self

            textView.textContainerInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
            textView.textContainer.lineFragmentPadding = 0

            // PollContent 적용
            applyFormattedPollContent(to: textView, with: pollContents[i])

            let tapGesture: UITapGestureRecognizer = .init(target: self,
                                                           action: #selector(textViewTapped(_:)))
            textView.addGestureRecognizer(tapGesture)
            textView.isUserInteractionEnabled = true

            textViews.append(textView)
            scrollView.addSubview(textView)
        }
    }

    /// 들여쓰기 문단 적용
    private func createParagraphStyle(withIndent indent: CGFloat) -> NSParagraphStyle {
        let paragraphStyle: NSMutableParagraphStyle = .init()
        paragraphStyle.firstLineHeadIndent = indent
        return paragraphStyle
    }

    private func setupActions() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
    }

    @objc
    private func confirmButtonTapped() {
        if confirmButton.backgroundColor == UIColor.gray {
            return
        }

        textViews[currentPage].resignFirstResponder()
        confirmButton.backgroundColor = .gray
        isPosted = false

        // extractPollDataFromCurrentTextView()
    }

    @objc
    private func textViewTapped(_ gesture: UITapGestureRecognizer) {
        if let textView = gesture.view as? UITextView {
            textView.becomeFirstResponder() // 편집 모드
        }
    }

    @objc
    private func pageControlChanged(_ sender: UIPageControl) {
        let page = sender.currentPage
        let xOffset = scrollView.frame.width * CGFloat(page)
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
        currentPage = page
    }
}

extension PollRecommendView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex: Int = .init(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = pageIndex
        currentPage = pageIndex
    }
}

extension PollRecommendView: UITextViewDelegate {
    func textViewDidBeginEditing(_: UITextView) {
        confirmButton.backgroundColor = .pointBlue
        isPosted = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if let index = textViews.firstIndex(of: textView) {
                applyFormattedPollContent(to: textView, with: pollContents[index])
            }
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            confirmButton.backgroundColor = .pointBlue
            isPosted = true
        }
    }
}

extension PollRecommendView {
    private func applyFormattedPollContent(to textView: UITextView, with content: PollContent) {
        let attributedText: NSMutableAttributedString = .init()

        // 1. 제목 스타일
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 24,
                                                                                       weight: .bold),
                                                              .foregroundColor: UIColor.black]
        attributedText.append(NSAttributedString(string: content.title + "\n\n",
                                                 attributes: titleAttributes))

        // 2. 본문 스타일
        let bodyAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16,
                                                                                      weight: .regular),
                                                             .foregroundColor: UIColor.black]
        attributedText.append(NSAttributedString(string: content.body + "\n\n",
                                                 attributes: bodyAttributes))

        // 3. 대화 스타일
        for (speaker, text) in content.dialogues {
            // 화자(Speaker) 스타일
            let speakerAttributes: [NSAttributedString.Key: Any] =
                [.font: UIFont.systemFont(ofSize: 20,
                                          weight: .bold),
                 .foregroundColor: UIColor.black]
            attributedText.append(NSAttributedString(string: speaker + "\n",
                                                     attributes: speakerAttributes))

            // 대화 내용 스타일
            let dialogueAttributes: [NSAttributedString.Key: Any] =
                [.font: UIFont.systemFont(ofSize: 16,
                                          weight: .regular),
                 .foregroundColor: UIColor
                     .black]
            attributedText.append(NSAttributedString(string: text + "\n\n",
                                                     attributes: dialogueAttributes))
        }

        // 4. 질문 스타일
        let questionAttributes: [NSAttributedString.Key: Any] =
            [.font: UIFont.systemFont(ofSize: 22,
                                      weight: .bold),
             .foregroundColor: UIColor.black]
        attributedText.append(NSAttributedString(string: content.question + "\n\n",
                                                 attributes: questionAttributes))

        // 5. Poll 옵션 소개 스타일
        let pollIntroAttributes: [NSAttributedString.Key: Any] =
            [.font: UIFont.systemFont(ofSize: 16,
                                      weight: .regular),
             .foregroundColor: UIColor.black]
        attributedText.append(NSAttributedString(string: "Poll opt.\n",
                                                 attributes: pollIntroAttributes))

        // 6. 선택지 스타일
        let optionAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16,
                                                                                        weight: .regular),
                                                               .foregroundColor: UIColor.black,
                                                               .paragraphStyle: createParagraphStyle(withIndent: 20)]

        // 각 선택지 추가
        for (index, option) in content.options.enumerated() {
            attributedText
                .append(NSAttributedString(string: option +
                        (index < content.options.count - 1 ? "\n" : ""),
                    attributes: optionAttributes))
        }

        // TextView에 적용
        textView.attributedText = attributedText

        // 타이핑 속성 설정 (유저가 텍스트 입력시 사용됨)
        textView.typingAttributes = [.font: UIFont.systemFont(ofSize: 16),
                                     .foregroundColor: UIColor.black]
    }
}
