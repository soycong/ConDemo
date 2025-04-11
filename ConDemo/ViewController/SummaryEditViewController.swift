//
//  SummaryEditViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/11/25.
//

import UIKit

final class SummaryEditViewController: UIViewController {
    // MARK: - Properties

    private let summaryEditView: SummaryEditView = .init()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view = summaryEditView

        setupNavigationBar()
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

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
