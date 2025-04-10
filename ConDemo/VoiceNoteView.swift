//
//  VoiceNoteiew.swift
//  ConDemo
//
//  Created by seohuibaek on 4/9/25.
//

import UIKit

final class VoiceNoteView: UIView {
    
    var messages: [Message] = Message.dummyMessages
    var highlightText = ""
    
    // 매칭 구현
    private var matchedWordIndexPaths: [IndexPath] = []
    private var currentMatchIndex: Int = -1
        
    private var messageBubbleTableView = MessageBubbleTableView()
    
    private var voiceNoteSearchBar = VoiceNoteSearchBar()
    
    private let upButton: UIButton = {
        let button = UIButton()
        
        button.setButtonWithSystemImage(imageName: ButtonSystemIcon.upButtonImage)
        
        return button
    }()
    
    private let downButton: UIButton = {
        let button = UIButton()
        
        button.setButtonWithSystemImage(imageName: ButtonSystemIcon.downButtonImage)
        
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        button.setButtonWithSystemImage(imageName: ButtonSystemIcon.cancelButtonImage)
        
        return button
    }()
    
    private lazy var messageStackView = {
        let stackView = UIStackView(arrangedSubviews: [messageBubbleTableView, searchStackView])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var systemButtonStackView = {
        let stackView = UIStackView(arrangedSubviews: [upButton, downButton, cancelButton])
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var searchStackView = {
        let stackView = UIStackView(arrangedSubviews: [voiceNoteSearchBar, systemButtonStackView])
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setUpTableView()
        setUpSearchBar()
        setSearchModeButtons()
        
        configureUI()

        hideSearchModeButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTableView() {
        messageBubbleTableView.delegate = self
        messageBubbleTableView.dataSource = self
    }
    
    private func setUpSearchBar() {
        voiceNoteSearchBar.delegate = self
    }
    
    private func setSearchModeButtons() {
        upButton.addTarget(self, action: #selector(upButtonTapped), for: .touchUpInside)
        downButton.addTarget(self, action: #selector(downButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    // 버튼 표시/숨김
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

    @objc private func upButtonTapped() {
        guard !matchedWordIndexPaths.isEmpty else { return }
        
        // 이전 결과로 이동 (위로)
        currentMatchIndex = (currentMatchIndex - 1 + matchedWordIndexPaths.count) % matchedWordIndexPaths.count
        scrollToCurrentMatch()
        
        updateMatchCounter()
    }

    @objc private func downButtonTapped() {
        guard !matchedWordIndexPaths.isEmpty else { return }
        
        // 다음 결과로 이동 (아래로)
        currentMatchIndex = (currentMatchIndex + 1) % matchedWordIndexPaths.count
        scrollToCurrentMatch()
        
        updateMatchCounter()
    }

    @objc private func cancelButtonTapped() {
        voiceNoteSearchBar.text = nil
        voiceNoteSearchBar.resignFirstResponder()
        highlightText = ""
        messageBubbleTableView.reloadData()

        hideSearchModeButtons()
    }
    
    private func configureUI(){
        addSubview(messageStackView)
        
        messageStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        messageBubbleTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(voiceNoteSearchBar.snp.top).offset(-10)
            make.top.equalToSuperview().offset(20)
        }
    }
}

extension VoiceNoteView: UITableViewDelegate {
    
}

extension VoiceNoteView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageBubbleCell.id, for: indexPath) as? MessageBubbleCell else {
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
        guard let searchText = searchBar.text else { return }
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
    
    // 매칭된 결과로 스크롤
    private func scrollToCurrentMatch() {
        guard currentMatchIndex >= 0 && currentMatchIndex < matchedWordIndexPaths.count else {
            return
        }
        
        let indexPath = matchedWordIndexPaths[currentMatchIndex]
        messageBubbleTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    // 결과 카운트
    private func updateMatchCounter() {
        print("현재 검색 위치: \(currentMatchIndex + 1)/\(matchedWordIndexPaths.count)")
    }
}
