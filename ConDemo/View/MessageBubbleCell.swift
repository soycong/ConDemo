//
//  MessageBubbleCell.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit

protocol MessageBubbleCellDelegate: AnyObject {
    func didTapAudioButton(in cell: MessageBubbleCell, audioURL: URL, audioData: Data?)
}

final class MessageBubbleCell: UITableViewCell {
    // MARK: - Static Properties

    static let id = "MessageBubbleCell"

    // MARK: - Properties

    weak var delegate: MessageBubbleCellDelegate?

    private var audioURL: URL?
    private var audioData: Data?

    private var bubbleBackgroundView: UIView = .init()

    private let messageLabel: UILabel = {
        let label: UILabel = .init()

        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping // 단어 단위 줄바꿈

        return label
    }()

    private let nicknameLabel: UILabel = {
        let label: UILabel = .init()

        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray

        return label
    }()

    private let dateLabel: UILabel = {
        let label: UILabel = .init()

        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray

        return label
    }()

    private let messageImageView: UIImageView = {
        let imageView: UIImageView = .init()

        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let audioButton: UIButton = {
        let button: UIButton = .init()

        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.tintColor = .systemBackground

        return button
    }()

    private let timeLabel: UILabel = {
        let label: UILabel = .init()

        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemBackground
        label.text = "0:00 / 0:00"
        label.textAlignment = .center

        return label
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear

        configureUI()
        setupAudio()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

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
            bubbleBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, // 왼쪽 상단
                                                        .layerMaxXMinYCorner, // 오른쪽 상단
                                                        .layerMinXMaxYCorner, // 왼쪽 상단
            ]

            bubbleBackgroundView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(10)
                make.leading.greaterThanOrEqualTo(contentView.snp.leading).offset(50)
                make.top.bottom.equalToSuperview().inset(12)
            }
        } else {
            messageLabel.textColor = .label
            messageLabel.textAlignment = .left

            bubbleBackgroundView.backgroundColor = .systemGray4
            bubbleBackgroundView.layer.cornerRadius = 15

            // 특정 모서리만 둥글게 설정
            bubbleBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, // 왼쪽 상단
                                                        .layerMaxXMinYCorner, // 오른쪽 상단
                                                        .layerMaxXMaxYCorner, // 오른쪽 상단
            ]

            bubbleBackgroundView.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(10)
                make.trailing.lessThanOrEqualTo(contentView.snp.trailing).offset(-50)
                make.top.bottom.equalToSuperview().inset(12)
            }
        }

        messageLabel.isHidden = true
        messageImageView.isHidden = true
        audioButton.isHidden = true
        timeLabel.isHidden = true

        if let image = message.image { // 이미지만 표시
            messageImageView.isHidden = false
            messageImageView.image = image

            messageImageView.snp.removeConstraints()

            messageImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(10)
                make.width.height.lessThanOrEqualTo(200)
            }

            messageImageView.clipsToBounds = true

        } else if message.audioURL != nil { // 오디오 버튼 표시
            audioButton.isHidden = false
            timeLabel.isHidden = false

            timeLabel.text = "0:00 / 0:00"

            audioURL = message.audioURL
            audioData = message.audioData

            if message.isFromCurrentUser {
                audioButton.tintColor = .white
                timeLabel.textColor = .white
            } else {
                audioButton.tintColor = .black
                timeLabel.textColor = .darkGray
            }

        } else { // 텍스트만 표시
            messageLabel.isHidden = false
            messageLabel.text = message.text
        }

        messageLabel.attributedText = message.text.makeAttributedString(searchText,
                                                                        font: messageLabel.font,
                                                                        backgroundColor: .gray)
    }

    func updateAudioButtonIcon(isPlaying: Bool) {
        let imageName = isPlaying ? "pause.circle.fill" : "play.circle.fill"
        audioButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    func updateTimeLabel(current: String, total: String) {
        timeLabel.text = "\(current) / \(total)"
    }

    private func configureUI() {
        contentView.addSubview(bubbleBackgroundView)
        bubbleBackgroundView.addSubview(messageLabel)
        bubbleBackgroundView.addSubview(messageImageView)
        bubbleBackgroundView.addSubview(audioButton)
        bubbleBackgroundView.addSubview(timeLabel)

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 16, bottom: 10,
                                                             right: 16))
        }

        audioButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }

        timeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(audioButton.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
    }

    private func setupAudio() {
        audioButton.addTarget(self, action: #selector(audioButtonTapped), for: .touchUpInside)
    }

    @objc
    private func audioButtonTapped() {
        if let url = audioURL {
            delegate?.didTapAudioButton(in: self, audioURL: url, audioData: audioData)
        }
    }
}
