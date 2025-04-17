//
//  LoadingIndicatorView.swift
//  ConDemo
//
//  Created by 이명지 on 4/17/25.
//

import UIKit

final class LoadingIndicatorView: UIView {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.trackTintColor = .systemGray5
        progress.progressTintColor = .systemBlue
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    // MARK: - Properties
    
    private var hasProgressBar: Bool = false
    
    // MARK: - Initialization
    
    init(title: String, message: String, showProgressBar: Bool = false) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        messageLabel.text = message
        hasProgressBar = showProgressBar
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(activityIndicator)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        
        if hasProgressBar {
            containerView.addSubview(progressView)
        }
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            
            activityIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ])
        
        if hasProgressBar {
            NSLayoutConstraint.activate([
                progressView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
                progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                progressView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                containerView.bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 24)
            ])
        } else {
            NSLayoutConstraint.activate([
                containerView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24)
            ])
        }
    }
    
    // MARK: - Public Methods
    
    func show(in view: UIView) {
        // 메인 스레드에서 실행되는지 확인
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.show(in: view)
            }
            return
        }
        
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 로딩 인디케이터를 최상위 계층으로 가져옴
        view.bringSubviewToFront(self)
        activityIndicator.startAnimating()
        
        // 애니메이션 효과
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.containerView.transform = .identity
            self.containerView.alpha = 1
        }
    }
    
    func updateMessage(_ message: String) {
        // 메인 스레드에서 UI 업데이트
        if Thread.isMainThread {
            messageLabel.text = message
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.messageLabel.text = message
            }
        }
    }
    
    func updateProgress(_ progress: Float) {
        guard hasProgressBar else { return }
        
        // 메인 스레드에서 UI 업데이트
        if Thread.isMainThread {
            progressView.progress = progress
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.progressView.progress = progress
            }
        }
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        // 메인 스레드에서 UI 업데이트
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.dismiss(completion: completion)
            }
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.containerView.alpha = 0
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
}
