//
//  StruggleJournalView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/10/25.
//

import UIKit

final class StruggleJournalView: UIView {
    
    private var isConfirmed = false
    private let placeholderText = "왜 싸웠나요? \n\n어떤 게 제일 화가 났나요? \n\n하지 말아야 했던 말은 없었나요? \n\n듣고 싶었던 말은 무엇이었나요? \n\n상대에게 미안한 것은 무엇인가요? \n\n어떤 걸 고쳐나가고 싶나요?"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "싸움로그 남기기"
        
        return label
    }()
    
    private(set) var confirmButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Confirm", for: .normal)
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
    
    private(set) var journalTextView: UITextView = {
        let textView = UITextView()
        
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .white
        
        textView.textColor = UIColor.lightGray
        textView.font = UIFont(name: "Pretendard-Medium", size: 14)
                
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
        let stackView = UIStackView(arrangedSubviews: [titleStackView, dateLabel, journalTextView])
        
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
        
        journalTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(40)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    private func setupTextView() {
        journalTextView.delegate = self
        journalTextView.text = placeholderText
        journalTextView.inputAccessoryView = setupKeyboardToolBar()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewTapped))
        journalTextView.addGestureRecognizer(tapGesture)
        journalTextView.isUserInteractionEnabled = true
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
    
    private func setupActions(){
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc private func confirmButtonTapped() {
        if confirmButton.backgroundColor == UIColor.gray {
            return
        }
        
        journalTextView.resignFirstResponder()
        confirmButton.backgroundColor = .gray
        isConfirmed = false
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
    
    @objc private func dismissKeyboard() {
        if journalTextView.isFirstResponder {
            journalTextView.resignFirstResponder()
        }
    }
}

extension StruggleJournalView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
        
        if textView.text.count >= 1 {
            confirmButton.backgroundColor = .pointBlue
            isConfirmed = true
        } else {
            confirmButton.backgroundColor = .gray
            isConfirmed = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
            confirmButton.backgroundColor = .gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty && textView.text != placeholderText {
            confirmButton.backgroundColor = .pointBlue
            isConfirmed = true
        }
    }
}
