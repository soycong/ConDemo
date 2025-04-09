//
//  MessageBubbleTableView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/9/25.
//

import UIKit

final class MessageBubbleTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        separatorStyle = .none
        register(MessageBubbleCell.self, forCellReuseIdentifier: MessageBubbleCell.id)
        // transform = CGAffineTransform(scaleX: 1, y: -1) // y: -1 -> 뷰를 수직으로 뒤집음
        
        // rowHeight = UITableView.automaticDimension
        // estimatedRowHeight = 60
    }
}
