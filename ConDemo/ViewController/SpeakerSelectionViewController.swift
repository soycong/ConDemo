//
//  SpeakerSelectionViewController.swift
//  ConDemo
//
//  Created by 이명지 on 4/24/25.
//

import UIKit

final class SpeakerSelectionViewController: UIViewController {
    private let speakerSelectionView = SpeakerSelectionView()
    private let viewModel: SpeakerSelectionViewModel
    
    init(analysisData: AnalysisData) {
        self.viewModel = SpeakerSelectionViewModel(analysisData: analysisData)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = speakerSelectionView
        setupData()
        setupAddTargets()
        setupNavigationBar()
    }
    
    private func setupData() {
        speakerSelectionView.messages = viewModel.getMessages()
    }
    
    private func setupAddTargets() {
        speakerSelectionView.addTargetToCompleteButton(
            target: self,
            action: #selector(completeButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "화자 선택"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .init(systemName: ButtonSystemIcon.cancelButtonImage),
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }
    
    @objc
    private func completeButtonTapped() {
        guard let selectedUserType = speakerSelectionView.isFromCurrentUser else {
            return
        }
        
        let needToSwitchSpeakers = viewModel.isCurrentUser(selectedUserType) == false
        
        if needToSwitchSpeakers {
            viewModel.switchSpeakers()
        } else {
            viewModel.modifySummaryData(needModify: false)
        }
        
        CoreDataManager.shared.saveAnalysis(data: viewModel.analysisData)
        
        let title = viewModel.analysisData.title
        let summaryVC = SummaryViewController(analysisTitle: title)
        navigationController?.pushViewController(summaryVC, animated: true)
    }
    
    @objc
    private func cancelButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
