//
//  MessageViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit

final class MessageViewController: UIViewController {
    let messageView = MessageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view = messageView
    }
}
