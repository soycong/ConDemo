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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        view = historyView
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = .none
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .init(systemName: ButtonSystemIcon.cancelButtonImage),
                                                           style: .plain, target: self,
                                                           action: #selector(backButtonTapped))
        navigationItem
            .rightBarButtonItem = UIBarButtonItem(image: .init(systemName: "person.circle"),
                                                  style: .plain, target: self,
                                                  action: #selector(profileButtonTapped))
    }
}

extension HistoryViewController {
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

//    @objc
//    private func calendarButtonTapped() {
//        let calendarView: CalendarView = .init()
//        calendarView.show(in: summaryView)
//    }

    @objc
    private func profileButtonTapped() { }
}
