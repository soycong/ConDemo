//
//  MessageView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit
import SnapKit

final class MessageView: UIView {
    
    var messages: [Message] = Message.dummyMessages
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "팩트 체크하기"
        
        return label
    }()
    
    private(set) var addButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .pointBlue
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    private var messageBubbleTableView = MessageBubbleTableView()
    
    private let inputTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "입력"
        textField.addLeftPadding()
        
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let image = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: config)
        
        button.setImage(image, for: .normal)
        button.tintColor = .pointBlue
        
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        
        return view
    }()
    
    private lazy var titleStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, addButton])
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var messageStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView, messageBubbleTableView, containerView])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        inputTextField.delegate = self
        
        setUpTableView()
        configureUI()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTableView() {
        messageBubbleTableView.delegate = self
        messageBubbleTableView.dataSource = self
    }
    
    private func configureUI(){
        addSubview(messageStackView)
        
        containerView.addSubview(inputTextField)
        containerView.addSubview(sendButton)
        
        messageStackView.snp.makeConstraints { make in
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
        
        addButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        
        messageBubbleTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleStackView.snp.bottom).offset(10)
            make.bottom.equalTo(inputTextField.snp.top).offset(-10)
        }
        
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.verticalEdges.equalToSuperview()
            make.trailing.equalTo(sendButton.snp.leading)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    private func setActions() {
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    @objc private func sendButtonTapped() {
        sendMessage()
    }
    
    private func sendMessage() {
        guard let text = inputTextField.text, !text.isEmpty else { return }
        
        messages.append(Message(text: text, isFromCurrentUser: true, timestamp: Date()))
        
        messageBubbleTableView.reloadData()
        
        if !messages.isEmpty {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            messageBubbleTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
        inputTextField.text = ""
    }
}

extension MessageView: UITableViewDelegate {
    
}

extension MessageView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageBubbleCell.id, for: indexPath) as? MessageBubbleCell else {
            return UITableViewCell()
        }
        
        let message = messages[indexPath.row]
        cell.configure(with: message)
        
        // cell.transform = CGAffineTransform(scaleX: 1, y: -1) // 아래부터 보여야하므로 셀 뒤집기
        
        return cell
    }
}

extension MessageView: UITextFieldDelegate {
    // return 버튼 눌렀을 때 메세지 보내지기
    // ViewController로 분리 해야함
//    func textField( _ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard string != "\n" else {
//            guard let text = inputTextField.text, !text.isEmpty else { return true }
//            
//            messages.append(Message(text: text, isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3600 * 3)))
//            messageBubbleTableView.reloadData()
//            inputTextField.text = ""
//
//            return false
//        }
//        
//        return true
//    }
}
