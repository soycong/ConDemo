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
    private let calendarView: CalendarView = .init()
    
    // MARK: - Lifecycle
    
    init(analysisTitle: String, isHistoryView: Bool = false) {
        self.analysisTitle = analysisTitle
        self.viewModel = SummaryViewModel(analysisTitle: analysisTitle)
        super.init(nibName: nil, bundle: nil)
        setupNavigationBar(isHistoryView: isHistoryView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupAddTargets()
        setupDelegates()
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

    private func setupNavigationBar(isHistoryView: Bool) {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = .none
        
        if isHistoryView {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: .init(systemName: ButtonSystemIcon.backButtonImage),
                                                               style: .plain, target: self,
                                                               action: #selector(backButtonTapped))
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
            
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: .init(systemName: ButtonSystemIcon.cancelButtonImage),
                                                               style: .plain, target: self,
                                                               action: #selector(cancelButtonTapped))
        }
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
    
    private func setupDelegates() {
        calendarView.delegate = self
    }
}

extension SummaryViewController {
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func cancelButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc
    private func calendarButtonTapped() {
        // CoreData에서 분석 데이터가 있는 날짜 가져오기
        /// 나중에 calendarViewMode l만들기
        let analysisAvailableDates = viewModel.fetchAnalysisAvailableDates()
        
        // 가져온 날짜들만 달력에 마킹
        calendarView.markDates(analysisAvailableDates)
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
            destinationVC = StruggleJournalViewController(analysisTitle: analysisTitle)
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

extension SummaryViewController: CalendarViewDelegate {
    func calendarView(_: CalendarView, didSelectDate selectedDate: Date) {
        if let analysis = viewModel.fetchAnalysisForDate(selectedDate), let title = analysis.title {
            // 해당 날짜의 summary로 이동
            let summaryVC = SummaryViewController(analysisTitle: title)
            navigationController?.pushViewController(summaryVC, animated: true)
        } else {
            // 분석 데이터가 없을 경우 알림
            let alert = UIAlertController(
                title: "알림",
                message: "선택한 날짜에 분석 데이터가 없습니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }
}
