//
//  StruggleJournalViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/10/25.
//

import UIKit

final class StruggleJournalViewController: UIViewController {
    // MARK: - Properties

    private let struggleJournalView: StruggleJournalView = .init()
    private var viewModel: StruggleJournalViewModel

    // MARK: - Lifecycle
    init(analysisTitle: String) {
        self.viewModel = StruggleJournalViewModel(analysisTitle: analysisTitle)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view = struggleJournalView

        setupNavigationBar()
        setupActions()
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
    
    private func setupActions() {
        struggleJournalView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    private func updateViewWithData() {
        // 날짜 업데이트
        struggleJournalView.updateDate(viewModel.date)
        
        // 내용 업데이트
        struggleJournalView.updateContent(viewModel.logContent)
    }

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func confirmButtonTapped() {
        // 현재 텍스트뷰 내용 가져오기
        let content = struggleJournalView.getCurrentContent()
        
        // 플레이스홀더 텍스트인 경우 저장하지 않음
        if content == struggleJournalView.placeholderText || content.isEmpty {
            return
        }
        
        // ViewModel을 통해 내용 저장
        if viewModel.saveLog(content: content) {
            // 저장 성공 알림
            let alertController = UIAlertController(
                title: "저장 완료",
                message: "로그 내용이 저장되었습니다.",
                preferredStyle: .alert
            )
            
            alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            
            present(alertController, animated: true)
        }
    }
}
