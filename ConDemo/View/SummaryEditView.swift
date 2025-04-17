//
//  SummaryEditView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/11/25.
//

import SnapKit
import UIKit

final class SummaryEditView: UIView {
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

    private(set) var summaryTextView: UITextView = {
        let textView: UITextView = .init()

        textView.layer.cornerRadius = 10
        textView.backgroundColor = .backgroundGray

        textView.textColor = UIColor.lightGray
        textView.font = UIFont(name: "Pretendard-Medium", size: 14)

        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = true
        textView.showsVerticalScrollIndicator = false

        textView.textContainerInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        textView.textContainer.lineFragmentPadding = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        let attributedString = NSAttributedString(
            string: "",
            attributes: [
                .paragraphStyle: paragraphStyle
            ]
            )
        textView.attributedText = attributedString

        return textView
    }()

    var placeholderText = "내용을 입력해주세요."
    private var isPosted = false
    private var summaryTextViewBottomConstraint: Constraint?

    private let titleLabel: UILabel = {
        let label: UILabel = .init()

        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "요약"

        return label
    }()

    private let dateLabel: UILabel = {
        let label: UILabel = .init()

        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "2025.04.10 오후 17:00"

        return label
    }()

    private lazy var titleStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [titleLabel, confirmButton])

        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill

        return stackView
    }()

    private lazy var summaryStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [titleStackView, dateLabel,
                                                              summaryTextView])

        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill

        return stackView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .baseBackground

        configureUI()
        setupTextView()
        setupActions()

        setupKeyboard(bottomConstraint: summaryTextViewBottomConstraint!,
                      defaultInset: 70,
                      textViews: [summaryTextView])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeKeyboard()
    }

    // MARK: - Functions

    private func configureUI() {
        addSubview(summaryStackView)

        summaryStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
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

        summaryTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(40)
            self.summaryTextViewBottomConstraint = make.bottom.equalToSuperview().inset(30)
                .constraint
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }

    private func setupTextView() {
        summaryTextView.delegate = self
        
        // 플레이스홀더 텍스트에 행간 적용
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        let attributedString = NSAttributedString(
            string: placeholderText,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.lightGray,
                .font: UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
            ]
        )
        
        summaryTextView.attributedText = attributedString
        
        // 타이핑 속성 설정 (사용자가 입력할 때 사용될 속성)
        summaryTextView.typingAttributes = [
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.label,
            .font: UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ]

        let tapGesture: UITapGestureRecognizer = .init(target: self,
                                                       action: #selector(textViewTapped))
        summaryTextView.addGestureRecognizer(tapGesture)
        summaryTextView.isUserInteractionEnabled = true
    }

    private func setupActions() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }

    @objc
    private func confirmButtonTapped() {
        if confirmButton.backgroundColor == UIColor.gray {
            return
        }

        dismissKeyboard()

        summaryTextView.resignFirstResponder()
        confirmButton.backgroundColor = .gray
        isPosted = false
    }

    @objc
    private func textViewTapped(_ gesture: UITapGestureRecognizer) {
        if let textView = gesture.view as? UITextView {
            if textView.isFirstResponder {
                textView.resignFirstResponder()
            } else {
                textView.becomeFirstResponder()
            }
        }
    }
}

extension SummaryEditView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.attributedText.string == placeholderText {
            // 빈 문자열로 설정하되, 같은 스타일 유지
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            
            let attributedString = NSAttributedString(
                string: "",
                attributes: [
                    .paragraphStyle: paragraphStyle,
                    .foregroundColor: UIColor.label,
                    .font: UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
                ]
            )
            
            textView.attributedText = attributedString
        }

        if textView.text.count >= 1 && textView.text != placeholderText {
            confirmButton.backgroundColor = .pointBlue
            isPosted = true
        } else {
            confirmButton.backgroundColor = .gray
            isPosted = false
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            // 플레이스홀더 설정, 스타일 유지
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            
            let attributedString = NSAttributedString(
                string: placeholderText,
                attributes: [
                    .paragraphStyle: paragraphStyle,
                    .foregroundColor: UIColor.lightGray,
                    .font: UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
                ]
            )
            
            textView.attributedText = attributedString
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty && textView.text != placeholderText {
            confirmButton.backgroundColor = .pointBlue
            isPosted = true
        }
    }
}

// SummaryEditView.swift에 추가할 확장 메소드들

extension SummaryEditView {
    // 날짜 업데이트
    func updateDate(_ date: String) {
        if !date.isEmpty {
            dateLabel.text = date
        }
    }
    
    // 제목 업데이트
    func updateTitle(_ title: String) {
        if !title.isEmpty {
            titleLabel.text = title
        }
    }
    
    // 내용 업데이트
    func updateContent(_ content: String) {
        if !content.isEmpty && content != placeholderText {
            // 내용 업데이트할 때도 행간 유지
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            
            let attributedString = NSAttributedString(
                string: content,
                attributes: [
                    .paragraphStyle: paragraphStyle,
                    .foregroundColor: UIColor.label,
                    .font: UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
                ]
            )
            
            summaryTextView.attributedText = attributedString
            
            // 내용이 있으면 확인 버튼 활성화
            confirmButton.backgroundColor = .pointBlue
            isPosted = true
        }
    }
    
    // 현재 내용 가져오기
    func getCurrentContent() -> String {
        // 플레이스홀더가 아닌 경우에만 내용 반환
        if summaryTextView.textColor == .lightGray || summaryTextView.text == placeholderText {
            return ""
        }
        return summaryTextView.text
    }
    
    // 텍스트뷰가 비어있는지 확인
    var isEmpty: Bool {
        return summaryTextView.text.isEmpty || summaryTextView.text == placeholderText || summaryTextView.textColor == .lightGray
    }
    
    // 플레이스홀더 텍스트 반환
    var getPlaceholderText: String {
        return placeholderText
    }
}
