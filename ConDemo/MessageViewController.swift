//
//  MessageViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit

final class MessageViewController: UIViewController {
    private let messageView = MessageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = messageView
    }
}
