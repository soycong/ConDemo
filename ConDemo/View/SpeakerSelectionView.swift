//
//  SpeakerSelectionView.swift
//  ConDemo
//
//  Created by 이명지 on 4/24/25.
//

import SnapKit
import UIKit

final class SpeakerSelectionView: UIView {
    // MARK: - Properties
    
    var messages: [MessageData] = []
    var isFromCurrentUser: Bool? {
        didSet {
            updateCompleteButtonState()
        }
    }
    
    var messageBubbleTableView: MessageBubbleTableView = .init()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "보다 정확한 분석을 위해 본인이 했던 말을 선택해 주세요"
        label.textColor = .systemGray
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray.withAlphaComponent(0.2)
        return view
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.setTitle("선택 완료", for: .normal)
        button.layer.cornerRadius = 14
        button.backgroundColor = .systemGray
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundGray
        
        setUpTableView()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setUpTableView() {
        messageBubbleTableView.delegate = self
        messageBubbleTableView.dataSource = self
        
        messageBubbleTableView.backgroundColor = .clear
        messageBubbleTableView.separatorStyle = .none
        messageBubbleTableView.allowsSelection = true
        
        messageBubbleTableView.register(MessageBubbleCell.self, forCellReuseIdentifier: MessageBubbleCell.id)
    }
    
    private func configureUI() {
        [instructionLabel, divider, messageBubbleTableView, completeButton].forEach {
            addSubview($0)
        }
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(26)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(14)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
        }
        
        messageBubbleTableView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalTo(completeButton.snp.top).offset(-20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(26)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    private func updateCompleteButtonState() {
        let isSelected = isFromCurrentUser != nil
        completeButton.isEnabled = isSelected
        completeButton.backgroundColor = isSelected ? .systemBlue : .systemGray
    }
    
    func addTargetToCompleteButton(target: Any?, action: Selector, for event: UIControl.Event) {
        completeButton.addTarget(target, action: action, for: event)
    }
}

extension SpeakerSelectionView: UITableViewDelegate {
    // 셀 선택 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        isFromCurrentUser = message.isFromCurrentUser
        
        messageBubbleTableView.reloadData()
    }
}

extension SpeakerSelectionView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageBubbleCell.id,
                                                       for: indexPath) as? MessageBubbleCell else {
            return UITableViewCell()
        }
        
        let message = messages[indexPath.row]
        
        // 선택 상태에 따라 셀 스타일 설정
        if let selectedUser = isFromCurrentUser {
            // 선택된 화자의 메시지 강조
            if message.isFromCurrentUser == selectedUser {
                cell.configure(with: message, isHighlighted: true)
            } else {
                // 선택되지 않은 화자 메시지 흐리게
                cell.configure(with: message, isDimmed: true)
            }
        } else {
            // 아무것도 선택 x
            cell.configure(with: message)
        }
        
        return cell
    }
}
