//
//  MessageView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import SnapKit
import UIKit

protocol MessageViewDelegate: AnyObject {
    func messageViewDidSendMessage(_ view: MessageView, message: String)
}

final class MessageView: UIView {
    // MARK: - Properties
    
    weak var delegate: MessageViewDelegate?
    
    // var messages: [MessageData] = MessageData.dummyMessages
    var messages: [MessageData] = [] {
        didSet {
            messageBubbleTableView.reloadData()
            scrollToBottom()
        }
    }
    
    private(set) var addButton: UIButton = {
        let button: UIButton = .init()

        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.backgroundColor = .pointBlue
        button.layer.cornerRadius = 4

        return button
    }()

    private weak var audioDelegate: MessageBubbleCellDelegate?
    private var messageStackViewBottomConstraint: Constraint?

    private let titleLabel: UILabel = {
        let label: UILabel = .init()

        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "팩트 체크하기"

        return label
    }()

    private var messageBubbleTableView: MessageBubbleTableView = .init()

    private let inputTextField: UITextField = {
        let textField: UITextField = .init()

        textField.placeholder = "입력"
        textField.addLeftPadding()

        return textField
    }()

    private let sendButton: UIButton = {
        let button: UIButton = .init()

        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let image: UIImage = .init(systemName: "arrow.up.circle.fill", withConfiguration: config)!

        button.setImage(image, for: .normal)
        button.tintColor = .pointBlue

        return button
    }()

    private let containerView: UIView = {
        let view: UIView = .init()

        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1

        return view
    }()

    private lazy var titleStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [titleLabel, addButton])

        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill

        return stackView
    }()

    private lazy var messageStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [titleStackView,
                                                              messageBubbleTableView,
                                                              containerView])

        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill

        return stackView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .baseBackground
        inputTextField.delegate = self

        setUpTableView()
        configureUI()
        setupActions()
        setupKeyboardNotifications()

        DispatchQueue.main.async {
            self.scrollToBottom()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Functions
    func reloadData() {
        messageBubbleTableView.reloadData()
    }
    
    func setAudioDelegate(_ delegate: MessageBubbleCellDelegate) {
        audioDelegate = delegate
    }

    func sendImage(image: UIImage) {
        //         messages.append(MessageData(text: "이미지입니다.", isFromCurrentUser: true, timestamp: Date(),
        //                                    image: image))
        
        inputTextField.text = ""
        messageBubbleTableView.reloadData()
        scrollToBottom()
    }
    
    func sendAudioMessage(url: URL, data: Data) {
        //        messages.append(MessageData(text: "오디오", isFromCurrentUser: true, timestamp: Date(),
        //                                    image: nil,
        //                                    audioURL: url, audioData: data))
        
        messageBubbleTableView.reloadData()
        scrollToBottom()
    }
    
    private func setUpTableView() {
        messageBubbleTableView.delegate = self
        messageBubbleTableView.dataSource = self
        
        messageBubbleTableView.backgroundColor = .baseBackground
        messageBubbleTableView.showsVerticalScrollIndicator = false
        messageBubbleTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
    }
    
    private func configureUI() {
        addSubview(messageStackView)
        
        containerView.addSubview(inputTextField)
        containerView.addSubview(sendButton)
        
        messageStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            self.messageStackViewBottomConstraint = make.bottom.equalToSuperview().inset(30)
                .constraint
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
            make.bottom.equalTo(containerView.snp.top).offset(-10)
        }
        
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
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
    
    //    private func scrollToBottom() {
    //        guard !messages.isEmpty else {
    //            return
    //        }
    //
    //        let index: IndexPath = .init(row: messages.count - 1, section: 0)
    //        messageBubbleTableView.scrollToRow(at: index, at: .bottom, animated: false)
    //    }
    
    func scrollToBottom() {
        let numberOfRows = messageBubbleTableView.numberOfRows(inSection: 0)
        guard numberOfRows > 0 else { return }
        
        let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
        messageBubbleTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func setupActions() {
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        // 테이블뷰 탭하면 키보드 내리기
        let tapGesture: UITapGestureRecognizer = .init(target: self,
                                                       action: #selector(dismissKeyboard))
        messageBubbleTableView.addGestureRecognizer(tapGesture)
        // messageBubbleTableView.keyboardDismissMode = .interactive // 스크롤로도 키보드 내리기
    }

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
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
        
        scrollToBottom()
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
    
    @objc
    private func sendButtonTapped() {
        sendMessage()
    }
    
    //    private func sendMessage() {
    //        guard let text = inputTextField.text, !text.isEmpty else {
    //            return
    //        }
    //
    //        messages.append(MessageData(text: text, isFromCurrentUser: true, timestamp: Date()))
    //
    //        messageBubbleTableView.reloadData()
    //        inputTextField.text = ""
    //        scrollToBottom()
    //    }
    
    private func sendMessage() {
        guard let text = inputTextField.text, !text.isEmpty else { return }
        
        // 델리게이트에 메시지 전달
        delegate?.messageViewDidSendMessage(self, message: text)
        
        // 입력 필드 비우기
        inputTextField.text = ""
    }
}

extension MessageView: UITableViewDelegate { }

extension MessageView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageBubbleCell.id,
                                                       for: indexPath) as? MessageBubbleCell else {
            return UITableViewCell()
        }

        let message = messages[indexPath.row]
        cell.configure(with: message)
        cell.delegate = audioDelegate

        // cell.transform = CGAffineTransform(scaleX: 1, y: -1) // 아래부터 보여야하므로 셀 뒤집기

        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}

extension MessageView: UITextFieldDelegate {
    // return 버튼 눌렀을 때 메세지 보내지기
    // ViewController로 분리 해야함
//    func textField( _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
//    replacementString string: String) -> Bool {
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
