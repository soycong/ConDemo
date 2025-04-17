//
//  PollRecommendViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/10/25.
//

import UIKit

final class PollRecommendViewController: UIViewController {
    // MARK: - Properties

    private let pollRecommendView: PollRecommendView = .init()
    private var viewModel: PollRecommendViewModel
    
    // MARK: - Lifecycle
    
    init(analysisTitle: String) {
        self.viewModel = PollRecommendViewModel(analysisTitle: analysisTitle)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view = pollRecommendView
        setupNavigationBar()
        updateViewWithData()
    }

    // MARK: - Functions

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = .none

        let backButton: UIBarButtonItem = .init(image: UIImage(systemName: "chevron.left"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))

        let waveButton: UIBarButtonItem = .init(image: UIImage(systemName: "waveform"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))

        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = waveButton
    }
    
    private func updateViewWithData() {
        // 날짜 업데이트
        pollRecommendView.updateDate(viewModel.date)
        
        // Poll 콘텐츠 업데이트
        pollRecommendView.updatePollContents(viewModel.pollContents)
    }

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
