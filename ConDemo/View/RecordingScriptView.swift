//
//  RecordingScriptView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/16/25.
//

import SnapKit
import UIKit

final class RecordingScriptView: UIView {
    // MARK: - Properties

//    var messages: [Message] = Message.dummyMessages
    var messages: [Message] = []
    var highlightText = ""

    private var scriptStackViewBottomConstraint: Constraint?

    // 매칭 구현
    private var matchedWordIndexPaths: [IndexPath] = []
    private var currentMatchIndex: Int = -1

    private var voiceNoteSearchBar: VoiceNoteSearchBar = .init()
    
    var scriptTextView: UITextView = {
        let textView = UITextView()
        
        textView.text = "어 영상 좀 그만 봐 . 아 이거 내가 하루 스트레스 푸는거 아니야 또 뭐 맨날 피곤하다 . 왜 또 그래 . 지금 새벽 두시잖아 , 지금 . 내가 이걸로 좀 뭐라 하지 말라달라고 그랬잖아 . 내가 이거 오늘 하루 내가 이거 피로 겨우 푸는 건데 이걸로 뭐라고 . 아니 근데 영상을 보고 싶으면 다음날 그럼 피곤하다고 하지나 말던가 . 피곤할 수는 있지 . 근데 이것 이것조차 안 하면 내가 더 피곤하니까 해서 그래 . 잠을 자야 안 피곤 나지 . 이게 무슨 말이야 , 이게 도대체 ?"
        
        textView.layer.cornerRadius = 10

        textView.backgroundColor = .baseBackground

        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = true
        textView.showsVerticalScrollIndicator = false

        textView.textColor = .label
        textView.font = UIFont(name: "Pretendard-Medium", size: 14)
        
        // 문장 간격 조정
        let attributedString = NSMutableAttributedString(string: textView.text)

        let currentFont = textView.font ?? UIFont.systemFont(ofSize: 14)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10.0 // 줄 간격

        let attributes: [NSAttributedString.Key: Any] = [
            .font: currentFont,
            .paragraphStyle: paragraphStyle
        ]

        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        textView.attributedText = attributedString

        return textView
    }()

    private let upButton: UIButton = {
        let button: UIButton = .init()

        button.setButtonWithSystemImage(imageName: ButtonSystemIcon.upButtonImage)
        button.tintColor = .label

        return button
    }()

    private let downButton: UIButton = {
        let button: UIButton = .init()

        button.setButtonWithSystemImage(imageName: ButtonSystemIcon.downButtonImage)
        button.tintColor = .label

        return button
    }()

    private let cancelButton: UIButton = {
        let button: UIButton = .init()

        button.setButtonWithSystemImage(imageName: ButtonSystemIcon.cancelButtonImage)
        button.tintColor = .label

        return button
    }()

    private lazy var messageStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [scriptTextView,
                                                              searchStackView])

        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill

        return stackView
    }()

    private lazy var systemButtonStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [upButton, downButton, cancelButton])

        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill

        return stackView
    }()

    private lazy var searchStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [voiceNoteSearchBar,
                                                              systemButtonStackView])

        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill

        return stackView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundGray
        
        // setupTextView()
        setupKeyboardNotifications()
        setUpSearchBar()
        setSearchModeButtons()

        configureUI()

        hideSearchModeButtons()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Functions
    
//    private func setupTextView() {
//        scriptTextView.text = messages.last?.text
//    }

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        // 테이블뷰 탭하면 키보드 내리기
        let tapGesture: UITapGestureRecognizer = .init(target: self,
                                                       action: #selector(dismissKeyboard))
        scriptTextView.addGestureRecognizer(tapGesture)
    }

    private func setUpSearchBar() {
        voiceNoteSearchBar.delegate = self
    }

    private func setSearchModeButtons() {
        upButton.addTarget(self, action: #selector(upButtonTapped), for: .touchUpInside)
        downButton.addTarget(self, action: #selector(downButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }

    /// 버튼 표시/숨김
    private func showSearchModeButtons() {
        systemButtonStackView.isHidden = false

        UIView.animate(withDuration: 0.3) {
            self.systemButtonStackView.alpha = 1.0
        }
    }

    private func hideSearchModeButtons() {
        UIView.animate(withDuration: 0.3, animations: {
            self.systemButtonStackView.alpha = 0.0
        }) { _ in
            self.systemButtonStackView.isHidden = true
        }
    }

    private func configureUI() {
        addSubview(messageStackView)

        messageStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.top.equalTo(safeAreaLayoutGuide)
            self.scriptStackViewBottomConstraint = make.bottom.equalToSuperview().inset(30)
                .constraint
        }

        scriptTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(voiceNoteSearchBar.snp.top).offset(-10)
            make.top.equalToSuperview().offset(20)
        }
    }

    @objc
    private func upButtonTapped() {
        guard !matchedWordIndexPaths.isEmpty else {
            return
        }

        // 이전 결과로 이동 (위로)
        currentMatchIndex = (currentMatchIndex - 1 + matchedWordIndexPaths.count) %
            matchedWordIndexPaths.count
        scrollToCurrentMatch()
        updateMatchCounter()
    }

    @objc
    private func downButtonTapped() {
        guard !matchedWordIndexPaths.isEmpty else {
            return
        }

        // 다음 결과로 이동 (아래로)
        currentMatchIndex = (currentMatchIndex + 1) % matchedWordIndexPaths.count
        scrollToCurrentMatch()
        updateMatchCounter()
    }

    @objc
    private func cancelButtonTapped() {
        voiceNoteSearchBar.text = nil
        voiceNoteSearchBar.resignFirstResponder()
        highlightText = ""

        hideSearchModeButtons()
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let keyboardHeight = keyboardFrame.height
        let duration = notification
            .userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3

        scriptStackViewBottomConstraint?.update(inset: keyboardHeight + 10)

        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        let duration = notification
            .userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3

        scriptStackViewBottomConstraint?.update(inset: 30)

        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }
}

extension RecordingScriptView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        highlightText = searchText

        findAllMatchMessages(for: searchText)

        voiceNoteSearchBar.resignFirstResponder()

        if !matchedWordIndexPaths.isEmpty {
            scrollToCurrentMatch()
            updateMatchCounter()
        }

        showSearchModeButtons()
    }

    // 유저가 텍스트 입력했을 때
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        highlightText = searchText
//        messageBubbleTableView.reloadData()
//    }

//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        voiceNoteSearchBar.text = nil
//        voiceNoteSearchBar.resignFirstResponder() // 키보드 내림
//        highlightText = ""
//    }
}

extension RecordingScriptView {
    private func findAllMatchMessages(for searchText: String) {
        guard !searchText.isEmpty else {
            matchedWordIndexPaths = []
            currentMatchIndex = -1
            return
        }

        matchedWordIndexPaths = []

        // 더 좋은 방법은 없을까?
        for (index, message) in messages.enumerated() {
            if message.text.range(of: searchText, options: .caseInsensitive) != nil {
                matchedWordIndexPaths.append(IndexPath(row: index, section: 0))
            }
        }

        // 마지막 결과로 현재 인덱스 설정
        currentMatchIndex = matchedWordIndexPaths.isEmpty ? -1 : matchedWordIndexPaths.count - 1
    }

    /// 매칭된 결과로 스크롤
    private func scrollToCurrentMatch() {
        guard currentMatchIndex >= 0 && currentMatchIndex < matchedWordIndexPaths.count else {
            return
        }

        let indexPath = matchedWordIndexPaths[currentMatchIndex]
    }

    /// 결과 카운트
    private func updateMatchCounter() {
        print("현재 검색 위치: \(currentMatchIndex + 1)/\(matchedWordIndexPaths.count)")
    }
}
