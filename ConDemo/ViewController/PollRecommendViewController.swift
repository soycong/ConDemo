//
//  PollRecommendViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/10/25.
//

import UIKit

final class PollRecommendViewController: UIViewController {
    // MARK: - Properties
    
    private let analysisTitle: String
    private let pollRecommendView: PollRecommendView = .init()
    private var viewModel: PollRecommendViewModel
    private var sheetViewController: VoiceNoteViewController = .init()
    
    // MARK: - Lifecycle
    
    init(analysisTitle: String) {
        self.analysisTitle = analysisTitle
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
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
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
                                                action: #selector(waveButtonTapped))

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
    
    @objc
    private func waveButtonTapped() {
        // 트랜스크립트 데이터 로드
        let messages = CoreDataManager.shared.fetchMessages(from: analysisTitle)

        // VoiceNoteViewController의 viewModel에 메시지 설정
        sheetViewController.viewModel.messages = messages

        // VoiceNoteView에 메시지 직접 설정
        // TODO: - 뷰에서 메세지 참조하는 거 없애야됨...
        sheetViewController.voiceNoteView.messages = messages
        sheetViewController.voiceNoteView.messageBubbleTableView.reloadData()

        // 바텀 시트로 표시
        presentAsBottomSheet(sheetViewController)
    }

}

extension PollRecommendViewController: UISheetPresentationControllerDelegate {
    func presentAsBottomSheet(_ viewController: UIViewController) {
        // 시트 프레젠테이션 컨트롤러 구성
        let customIdentifier = UISheetPresentationController.Detent.Identifier("custom20")
        let customDetent = UISheetPresentationController.Detent
            .custom(identifier: customIdentifier) { _ in
                20 // 원하는 높이
            }

        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [customDetent,
                             .medium(), // 화면 중간 높이까지
                             .large(), // 전체 화면 높이
            ]

            sheet.delegate = self
            // 사용자가 시트를 끌어올릴 수 있도록 설정
            sheet.prefersGrabberVisible = true

            // 시작 시 어떤 높이로 표시할지 설정
            sheet.selectedDetentIdentifier = .large

            // 드래그 중에 아래 뷰가 어두워지지 않도록 설정
            sheet.largestUndimmedDetentIdentifier = .large
        }

        present(viewController, animated: true)
    }

    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        // 시트가 custom20 높이로 변경되면 dismiss
        if sheetPresentationController.selectedDetentIdentifier == UISheetPresentationController
            .Detent.Identifier("custom20") {
            // 약간의 지연 후에 dismiss 실행 (애니메이션이 자연스럽게 보이도록)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                sheetPresentationController.presentedViewController.dismiss(animated: true)
            }
        }
    }
}

//extension PollRecommendViewController: UIGestureRecognizerDelegate {
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        // 네비게이션 스택에 뷰 컨트롤러가 2개 이상 있는 경우에만 제스처 허용
//        return navigationController?.viewControllers.count ?? 0 > 1
//    }
//}
