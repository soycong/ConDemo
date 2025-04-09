//
//  VoiceNoteViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/9/25.
//

import UIKit

final class VoiceNoteViewController: UIViewController {
    private let voiceNoteView = VoiceNoteView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = voiceNoteView
    }
}

