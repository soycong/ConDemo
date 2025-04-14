//
//  HistoryViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/14/25.
//

import UIKit

final class HistoryViewController: UIViewController {
    
    // MARK: - Properties

    private let historyView: HistoryView = .init()
    private let calendarView: CalendarView = .init()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        setupView()
        setupNavigationBar()
        setupAddTargets()
    }
    
    private func setDelegates() {
        historyView.delegate = self
        calendarView.delegate = self
    }
    
    private func setupView() {
        view = historyView
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = .none
        
        // x버튼 어색해서 < 버튼으로 변경
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .init(systemName: ButtonSystemIcon.backButtonImage),
                                                           style: .plain, target: self,
                                                           action: #selector(xmarkButtonTapped))
        navigationItem
            .rightBarButtonItem = UIBarButtonItem(image: .init(systemName: "person.circle"),
                                                  style: .plain, target: self,
                                                  action: #selector(profileButtonTapped))
    }
}

extension HistoryViewController {
    private func setupAddTargets() {
        historyView.calenderButton.addTarget(self, action: #selector(calendarButtonTapped),
                                                 for: .touchUpInside)
    }
    
    @objc
    private func xmarkButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func calendarButtonTapped() {
        calendarView.show(in: historyView)
    }

    @objc
    private func profileButtonTapped() { }
    
    private func pushToSummaryViewController() {
        let summaryVC = SummaryViewController()
        navigationController?.pushViewController(summaryVC, animated: true)
    }
}

extension HistoryViewController: HistoryViewDelegate {
    func didSelectHistory(at index: Int) {
        pushToSummaryViewController()
    }
}

extension HistoryViewController: CalendarViewDelegate {
    func calendarView(_ calendarView: CalendarView, didSelectDate date: Date) {
        pushToSummaryViewController()
    }
}
