//
//  RecordingMainViewController.swift
//  ConDemo
//
//  Created by 이명지 on 4/9/25.
//

import UIKit

final class RecordingMainViewController: UIViewController {
    // MARK: - Properties

    private let recordingMainView: RecordingMainView = .init()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view = recordingMainView
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCurrentTime()
    }

    // MARK: - Functions

    private func setNavigationBar() {
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

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func calendarButtonTapped() { }

    @objc
    private func profileButtonTapped() { }
    
    private func setupCurrentTime() {
        recordingMainView.dateLabel.text = Date().toKoreaFormat().description
    }
}
