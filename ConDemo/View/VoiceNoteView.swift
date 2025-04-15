//
//  VoiceNoteView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/9/25.
//

import SnapKit
import UIKit

final class VoiceNoteView: UIView {
    // MARK: - Properties

    var messages: [Message] = Message.dummyMessages
    var highlightText = ""

    private var messageStackViewBottomConstraint: Constraint?

    // 매칭 구현
    private var matchedWordIndexPaths: [IndexPath] = []
    private var currentMatchIndex: Int = -1

    private var messageBubbleTableView: MessageBubbleTableView = .init()

    private var voiceNoteSearchBar: VoiceNoteSearchBar = .init()

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
        let stackView: UIStackView = .init(arrangedSubviews: [messageBubbleTableView,
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

        setupKeyboardNotifications()
        setUpTableView()
        setUpSearchBar()
        setSearchModeButtons()

        configureUI()

        hideSearchModeButtons()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

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
        messageBubbleTableView.addGestureRecognizer(tapGesture)
    }

    private func setUpTableView() {
        messageBubbleTableView.delegate = self
        messageBubbleTableView.dataSource = self

        messageBubbleTableView.backgroundColor = .clear
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
            self.messageStackViewBottomConstraint = make.bottom.equalToSuperview().inset(30)
                .constraint
        }

        messageBubbleTableView.snp.makeConstraints { make in
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
        messageBubbleTableView.reloadData()

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

        messageStackViewBottomConstraint?.update(inset: keyboardHeight + 10)

        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        let duration = notification
            .userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3

        messageStackViewBottomConstraint?.update(inset: 30)

        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension VoiceNoteView: UITableViewDelegate { }

extension VoiceNoteView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageBubbleCell.id,
                                                       for: indexPath) as? MessageBubbleCell else {
            return UITableViewCell()
        }

        let message = messages[indexPath.row]
        cell.configure(with: message, searchText: highlightText)

        // cell.transform = CGAffineTransform(scaleX: 1, y: -1) // 아래부터 보여야하므로 셀 뒤집기

        return cell
    }
}

extension VoiceNoteView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        highlightText = searchText

        findAllMatchMessages(for: searchText)

        messageBubbleTableView.reloadData()
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

extension VoiceNoteView {
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
        messageBubbleTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }

    /// 결과 카운트
    private func updateMatchCounter() {
        print("현재 검색 위치: \(currentMatchIndex + 1)/\(matchedWordIndexPaths.count)")
    }
}
