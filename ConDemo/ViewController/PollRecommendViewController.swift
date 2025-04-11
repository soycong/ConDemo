//
//  PollCreateViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/10/25.
//

import UIKit

final class PollRecommendViewController: UIViewController {
    
    private let pollRecommendView = PollRecommendView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = pollRecommendView
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = .none
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        
        let waveButton = UIBarButtonItem(image: UIImage(systemName: "waveform"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = waveButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
