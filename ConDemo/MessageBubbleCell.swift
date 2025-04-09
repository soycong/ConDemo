//
//  MessageBubbleCell.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit

final class MessageBubbleCell: UITableViewCell {
    static let id = "MessageBubbleCell"
    
    private var bubbleBackgroundView = UIView()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping  // 단어 단위 줄바꿈
        
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bubbleBackgroundView.snp.removeConstraints()
        messageLabel.snp.removeConstraints()
    }
    
    private func configureUI() {
        contentView.addSubview(bubbleBackgroundView)
        bubbleBackgroundView.addSubview(messageLabel)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
//        messageLabel.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview().inset(16)
//            make.centerY.equalToSuperview()
//        }
    }
    
    //    func configure(with message: Message, nickname: String, date: Date) {
    //        messageLabel.text = message.text
    //        nicknameLabel.text = nickname
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy.MM.dd"
    //
    //        let formattedDate = dateFormatter.string(from: date)
    //        dateLabel.text = "| \(formattedDate) "
    //
    //        if message.isFromCurrentUser {
    //            messageLabel.textColor = .blue
    //        } else {
    //            messageLabel.textColor = .black
    //        }
    //    }
    
    func configure(with message: Message, searchText: String = "") {
        messageLabel.text = message.text
        
        if message.isFromCurrentUser {
            messageLabel.textColor = .white
            messageLabel.textAlignment = .right
            
            bubbleBackgroundView.backgroundColor = .systemBlue
            bubbleBackgroundView.layer.cornerRadius = 15
            
            // 특정 모서리만 둥글게 설정
            bubbleBackgroundView.layer.maskedCorners = [
                .layerMinXMinYCorner, // 왼쪽 상단
                .layerMaxXMinYCorner,  // 오른쪽 상단
                .layerMinXMaxYCorner // 왼쪽 상단
            ]
            
            messageLabel.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
                // make.top.bottom.equalToSuperview().inset(4)
                make.top.equalToSuperview().offset(10)
            }
            
            bubbleBackgroundView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(10)
                make.leading.greaterThanOrEqualTo(contentView.snp.leading).offset(50)
            }
        } else {
            messageLabel.textColor = .white
            messageLabel.textAlignment = .left
            
            bubbleBackgroundView.backgroundColor = .orange
            bubbleBackgroundView.layer.cornerRadius = 15
            
            // 특정 모서리만 둥글게 설정
            bubbleBackgroundView.layer.maskedCorners = [
                .layerMinXMinYCorner, // 왼쪽 상단
                .layerMaxXMinYCorner,  // 오른쪽 상단
                .layerMaxXMaxYCorner // 오른쪽 상단
            ]
            
            messageLabel.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
                make.top.equalToSuperview().offset(10)
                // make.top.bottom.equalToSuperview().inset(4)
                make.height.greaterThanOrEqualTo(20)
            }
            
            bubbleBackgroundView.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(10)
                make.trailing.lessThanOrEqualTo(contentView.snp.trailing).offset(-50)
            }
        }
        
        let attributedText = NSMutableAttributedString(string: message.text)
        let range = (message.text as NSString).range(of: searchText)
        attributedText.addAttributes([.foregroundColor: UIColor.green], range: range)
        messageLabel.attributedText = attributedText
        
        //            let messageLabelText = messageLabel.attributedText?.string
        //            messageLabel.attributedText = messageLabelText?.makeAttributedString(searchText, font: messageLabel.font, color: .red)
        
        // print(messageLabelText)
    }
}
