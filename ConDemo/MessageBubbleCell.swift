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
    
    private let messageImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(bubbleBackgroundView)
        bubbleBackgroundView.addSubview(messageLabel)
        bubbleBackgroundView.addSubview(messageImageView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
        }
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
        bubbleBackgroundView.snp.removeConstraints()
        
        if message.isFromCurrentUser {
            messageLabel.textColor = .white
            messageLabel.textAlignment = .left
            
            bubbleBackgroundView.backgroundColor = .pointBlue
            bubbleBackgroundView.layer.cornerRadius = 15
            
            // 특정 모서리만 둥글게 설정
            bubbleBackgroundView.layer.maskedCorners = [
                .layerMinXMinYCorner, // 왼쪽 상단
                .layerMaxXMinYCorner,  // 오른쪽 상단
                .layerMinXMaxYCorner // 왼쪽 상단
            ]
            
            bubbleBackgroundView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(10)
                make.leading.greaterThanOrEqualTo(contentView.snp.leading).offset(50)
                make.top.bottom.equalToSuperview().inset(12)
            }
        } else {
            messageLabel.textColor = .black
            messageLabel.textAlignment = .left
            
            bubbleBackgroundView.backgroundColor = .systemGray4
            bubbleBackgroundView.layer.cornerRadius = 15
            
            // 특정 모서리만 둥글게 설정
            bubbleBackgroundView.layer.maskedCorners = [
                .layerMinXMinYCorner, // 왼쪽 상단
                .layerMaxXMinYCorner,  // 오른쪽 상단
                .layerMaxXMaxYCorner // 오른쪽 상단
            ]
            
            bubbleBackgroundView.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(10)
                make.trailing.lessThanOrEqualTo(contentView.snp.trailing).offset(-50)
                make.top.bottom.equalToSuperview().inset(12)
            }
        }
        
        messageLabel.attributedText = message.text.makeAttributedString(searchText, font: messageLabel.font, color: .red)
        
        if let image = message.image { // 이미지만 표시
            messageImageView.isHidden = false
            messageImageView.image = image
            messageLabel.isHidden = true
            
            messageImageView.snp.removeConstraints()
            
            messageImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(10)
                make.width.height.lessThanOrEqualTo(200)
            }
            
            messageImageView.clipsToBounds = true
            
        } else { // 텍스트만 표시
            messageImageView.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = message.text
        }
    }
}
