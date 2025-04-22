//
//  ChoiceViewController.swift
//  ConDemo
//
//  Created by 이명지 on 4/21/25.
//

import UIKit

final class ChoiceViewController: UIViewController {
    private let choiceView = ChoiceView()
    private let viewModel: ChoiceViewModel
    
    init(analysisData: AnalysisData) {
        self.viewModel = ChoiceViewModel(analysisData: analysisData)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = choiceView
        setupText()
        setupAddTargets()
        setupNavigationBar()
    }
}

extension ChoiceViewController {
    private func setupAddTargets() {
        [
            choiceView.myCheckButton,
            choiceView.yoursCheckButton
        ].forEach {
            $0.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        }
        
        choiceView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = .none

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .init(systemName: ButtonSystemIcon.cancelButtonImage),
                                                           style: .plain, target: self,
                                                           action: #selector(cancelButtonTapped))
    }
}

extension ChoiceViewController {
    @objc
    private func checkButtonTapped(_ sender: UIButton) {
        if sender == choiceView.myCheckButton {
            sender.isSelected.toggle()
            
            if sender.isSelected {
                choiceView.yoursCheckButton.isSelected = false
            }
        } else {
            sender.isSelected.toggle()
            
            if sender.isSelected {
                choiceView.myCheckButton.isSelected = false
            }
        }
        
        updateCompleteButtonState()
    }
    
    @objc
    private func completeButtonTapped() {
        let needToSwitchSpeakers = !choiceView.myCheckButton.isSelected
        choiceView.completeButton.isEnabled = false
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if needToSwitchSpeakers {
                self.viewModel.switchSpeakers()
            } else {
                self.viewModel.modifySummaryData(needModify: false)
            }
            
            CoreDataManager.shared.saveAnalysis(data: self.viewModel.analysisData)
            
            let title = self.viewModel.analysisData.title
            let summaryVC = SummaryViewController(analysisTitle: title)
            navigationController?.pushViewController(summaryVC, animated: true)
        }
        // 화자 그대로 -> SummaryData 수정
        // 화자 바뀜 -> MessagesData 수정, SummaryData 수정
    }
    
    @objc
    private func cancelButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension ChoiceViewController {
    private func updateCompleteButtonState() {
        let isButtonSelected = choiceView.myCheckButton.isSelected || choiceView.yoursCheckButton.isSelected
        choiceView.completeButton.isEnabled = isButtonSelected
        
        choiceView.completeButton.backgroundColor = isButtonSelected ? .systemBlue : .systemGray
    }
}

// 선택한 화자 맞는지 판별
extension ChoiceViewController {
    private func setupText() {
        let data = viewModel.extractData()
        choiceView.setupText(userA: data[0], userB: data[1])
    }
}
