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
    
    private var messageBubbleTableView = MessageBubbleTableView()
    
    private let inputTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "입력"
        textField.addLeftSystemImage(systemImageName: "magnifyingglass")
        
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 1
        textField.returnKeyType = .send
        
        return textField
    }()

    private lazy var messageStackView = {
        let stackView = UIStackView(arrangedSubviews: [messageBubbleTableView, inputTextField])
        
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
        
        messageStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        messageBubbleTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(inputTextField.snp.top).offset(-10)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(38)
        }
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
    func textField( _ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string != "\n" else {
            guard let text = inputTextField.text, !text.isEmpty else { return true }
            
            messages.append(Message(text: text, isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3600 * 3)))
            messageBubbleTableView.reloadData()
            inputTextField.text = ""

            return false
        }
        
        return true
    }
}
