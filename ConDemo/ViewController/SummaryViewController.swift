//
//  SummaryViewController.swift
//  ConDemo
//
//  Created by 이명지 on 4/11/25.
//

import UIKit

final class SummaryViewController: UIViewController {
    // MARK: - Properties

    private var analysisTitle: String
    private let summaryView: SummaryView = .init()
    private var viewModel: SummaryViewModel
    
    // MARK: - Lifecycle
    
    init(analysisTitle: String) {
        self.analysisTitle = analysisTitle
        self.viewModel = SummaryViewModel(analysisTitle: analysisTitle)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavigationBar()
        setupAddTargets()
    }
}

extension SummaryViewController {
    private func setupView() {
        // viewModel.analysis가 있으면 해당 데이터로 뷰 설정
        if let analysis = viewModel.analysis {
            summaryView.setupText(analysis: analysis)
        }
        view = summaryView
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = .none

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .init(systemName: "chevron.left"),
                                                           style: .plain, target: self,
                                                           action: #selector(backButtonTapped))
        navigationItem
            .rightBarButtonItems =
            [UIBarButtonItem(image: .init(systemName: "person.circle"),
                             style: .plain, target: self,
                             action: #selector(profileButtonTapped)),
             UIBarButtonItem(image: .init(systemName: "calendar"), style: .plain, target: self,
                             action: #selector(calendarButtonTapped))]
    }

    private func setupAddTargets() {
        [summaryView.factCheckButton,
         summaryView.logButton,
         summaryView.pollButton,
         summaryView.summaryButton].forEach {
            $0.addTarget(self, action: #selector(navigateToVC), for: .touchUpInside)
        }
    }
}

extension SummaryViewController {
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func calendarButtonTapped() {
        let calendarView: CalendarView = .init()
        calendarView.show(in: summaryView)
    }

    @objc
    private func profileButtonTapped() { }
}

extension SummaryViewController {
    @objc
    func navigateToVC(_ sender: UIButton) {
        let destinationVC: UIViewController

        switch sender.tag {
        case 1:
            destinationVC = MessageViewController(analysisTitle: analysisTitle)
        case 2:
            destinationVC = StruggleJournalViewController()
        case 3:
            destinationVC = PollRecommendViewController(analysisTitle: analysisTitle)
        case 4:
            destinationVC = SummaryEditViewController(analysisTitle: analysisTitle)
        default:
            return
        }

        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
