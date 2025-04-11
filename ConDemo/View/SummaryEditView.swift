//
//  SummaryEditView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/11/25.
//

import UIKit
import SnapKit

final class SummaryEditView: UIView {
    
    private let placeholderText = "내용을 입력해주세요."
    private var isPosted = false
    private var summaryTextViewBottomConstraint: Constraint?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "요약"
        
        return label
    }()
    
    private(set) var confirmButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Posting", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        
        button.backgroundColor = .gray
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "2025.04.10 오후 17:00"
        
        return label
    }()
    
    private(set) var summaryTextView: UITextView = {
        let textView = UITextView()
        
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .backgroundGray
        
        textView.textColor = UIColor.lightGray
        textView.font = UIFont(name: "Pretendard-Medium", size: 14)
        
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = true
        textView.showsVerticalScrollIndicator = false

        textView.textContainerInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        textView.textContainer.lineFragmentPadding = 0
        
        return textView
    }()
    
    private lazy var titleStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, confirmButton])
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var journalStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView, dateLabel, summaryTextView])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        configureUI()
        setupTextView()
        setupKeyboardNotifications()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        addSubview(journalStackView)
        
        journalStackView.snp.makeConstraints { make in
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
            // make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            self.summaryTextViewBottomConstraint = make.bottom.equalToSuperview().inset(30).constraint
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    private func setupTextView() {
        summaryTextView.delegate = self
        summaryTextView.text = placeholderText
        summaryTextView.inputAccessoryView = setupKeyboardToolBar()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewTapped))
        summaryTextView.addGestureRecognizer(tapGesture)
        summaryTextView.isUserInteractionEnabled = true
    }
    
    private func setupKeyboardToolBar() -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolBar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        
        toolBar.items = [flexSpace, doneButton]
        toolBar.sizeToFit()
        
        return toolBar
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupActions(){
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
        
        var contentInset = summaryTextView.contentInset
        contentInset.bottom = keyboardHeight
        summaryTextView.contentInset = contentInset
        
        var scrollIndicatorInsets = summaryTextView.scrollIndicatorInsets
        scrollIndicatorInsets.bottom = keyboardHeight
        summaryTextView.scrollIndicatorInsets = scrollIndicatorInsets
        
        if summaryTextView.isFirstResponder, let selectedRange = summaryTextView.selectedTextRange {
            summaryTextView.scrollRectToVisible(summaryTextView.caretRect(for: selectedRange.end), animated: true)
        }
        
        summaryTextViewBottomConstraint?.update(inset: keyboardHeight + 10)
        
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
        
        var contentInset = summaryTextView.contentInset
        contentInset.bottom = 0
        summaryTextView.contentInset = contentInset
        
        var scrollIndicatorInsets = summaryTextView.scrollIndicatorInsets
        scrollIndicatorInsets.bottom = 0
        summaryTextView.scrollIndicatorInsets = scrollIndicatorInsets
        
        summaryTextViewBottomConstraint?.update(inset: 30)
        
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }
    
    @objc private func dismissKeyboard() {
        if summaryTextView.isFirstResponder {
            summaryTextView.resignFirstResponder()
        }
        
        endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func confirmButtonTapped() {
        if confirmButton.backgroundColor == UIColor.gray {
            return
        }
        
        summaryTextView.resignFirstResponder()
        confirmButton.backgroundColor = .gray
        isPosted = false
    }
    
    @objc private func textViewTapped(_ gesture: UITapGestureRecognizer) {
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
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
        
        if textView.text.count >= 1 {
            confirmButton.backgroundColor = .pointBlue
            isPosted = true
        } else {
            confirmButton.backgroundColor = .gray
            isPosted = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty && textView.text != placeholderText {
            confirmButton.backgroundColor = .pointBlue
            isPosted = true
        }
    }
}
