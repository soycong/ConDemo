//
//  MessageBubbleTableView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/9/25.
//

import UIKit

final class MessageBubbleTableView: UITableView {
    // MARK: - Lifecycle

    override init(frame: CGRect, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)

        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func configure() {
        separatorStyle = .none
        register(MessageBubbleCell.self, forCellReuseIdentifier: MessageBubbleCell.id)
        // transform = CGAffineTransform(scaleX: 1, y: -1) // y: -1 -> 뷰를 수직으로 뒤집음

        // rowHeight = UITableView.automaticDimension
        // estimatedRowHeight = 60
    }
}
