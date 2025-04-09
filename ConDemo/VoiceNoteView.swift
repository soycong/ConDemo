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
        print("Up button tapped")
    }

    @objc private func downButtonTapped() {
        print("Down button tapped")
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
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(voiceNoteSearchBar.snp.top).offset(-10)
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
        
        messageBubbleTableView.reloadData()
        voiceNoteSearchBar.resignFirstResponder()
        
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
