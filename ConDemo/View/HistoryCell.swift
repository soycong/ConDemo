//
//  HistoryCell.swift
//  ConDemo
//
//  Created by seohuibaek on 4/14/25.
//

import UIKit

final class HistoryCell: UITableViewCell {
    // MARK: - Static Properties

    static let id = "HistoryCell"

    // MARK: - Properties

    private let emotionImageView: UIImageView = {
        let imageView: UIImageView = .init()

        // imageView.image = UIImage(named: "level9")

        return imageView
    }()

    private let dateLabel: UILabel = {
        let label: UILabel = .init()

        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        let formattedDate = dateFormatter.string(from: Date())
        label.text = "\(formattedDate) "

        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray

        return label
    }()

    private let unreadIcon: UIImageView = {
        let imageView: UIImageView = .init()

        // imageView.image = UIImage(named: "unreadIcon")

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label: UILabel = .init()

        label.text = "밥 먹다가 갑자기 싸움한... | 매운맛 8"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)

        return label
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .baseBackground

        contentView.backgroundColor = .backgroundGray
        contentView.layer.cornerRadius = 10

        accessoryType = .disclosureIndicator

        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overridden Functions

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        contentView.backgroundColor = selected ? .gray : .backgroundGray
//    }

    /// 하이라이트 애니메이션 효과 주기
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        UIView.animate(withDuration: 0.2) {
            self.contentView.backgroundColor = highlighted ? .lightGray : .backgroundGray

            // 약간의 스케일 효과 추가 (누를 때 살짝 작아지는 효과)
            if highlighted {
                self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            } else {
                self.transform = .identity
            }
        }
    }

    // MARK: - Functions
    func configure(imageName: String, dateText: String, titleText: String) {
        emotionImageView.image = UIImage(named: imageName)
        dateLabel.text = "\(dateText) "
        titleLabel.text = titleText
    }

    private func configureUI() {
        for item in [emotionImageView, dateLabel, unreadIcon, titleLabel] {
            contentView.addSubview(item)
        }

        contentView.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.horizontalEdges.equalToSuperview()
        }

        emotionImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(40)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(emotionImageView.snp.top)
            make.leading.equalTo(emotionImageView.snp.trailing).offset(10)
        }

        unreadIcon.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(10)
            make.centerY.equalTo(dateLabel.snp.centerY)
        }

        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(emotionImageView.snp.bottom)
            make.leading.equalTo(emotionImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(55)
        }
    }
}
