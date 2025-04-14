//
//  CustomAlertView.swift
//  ConDemo
//
//  Created by 이명지 on 4/10/25.
//

import UIKit

final class CustomAlertView: UIView {
    // MARK: - Properties

    var completion: (() -> Void)?

    private var backgroundView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        return view
    }()

    private var alertView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()

    private var messageLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        return label
    }()

    private var continueButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 14
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [messageLabel, continueButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        setupGestures()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomAlertView {
    private func setupSubviews() {
        addSubview(backgroundView)
        backgroundView.addSubview(alertView)
        alertView.addSubview(stackView)
    }

    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(284)
            make.height.equalTo(173)
        }

        continueButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(11)
            make.verticalEdges.equalToSuperview().inset(13)
        }
    }

    private func setupGestures() {
        let tapGesture: UITapGestureRecognizer = .init(target: self,
                                                       action: #selector(backgroundViewTapped))
        tapGesture.delegate = self
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isUserInteractionEnabled = true

        continueButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }
}

extension CustomAlertView {
    func show(in superView: UIView, message: String, completion: (() -> Void)? = nil) {
        self.completion = completion

        let paragraphStyle: NSMutableParagraphStyle = .init()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Pretendard-SemiBold",
                                                                       size: 18),
                                                         .foregroundColor: UIColor.black,
                                                         .paragraphStyle: paragraphStyle]

        let attributedString: NSAttributedString = .init(string: message, attributes: attributes)
        messageLabel.attributedText = attributedString

        frame = superView.bounds

        alertView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        alertView.alpha = 0
        backgroundView.alpha = 0

        superView.addSubview(self)

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.backgroundView.alpha = 1
            self.alertView.transform = .identity
            self.alertView.alpha = 1
        }
    }

    @objc
    private func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0
            self.alertView.alpha = 0
            self.alertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.removeFromSuperview()
            self.completion?()
        })
    }

    @objc
    private func backgroundViewTapped() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0
            self.alertView.alpha = 0
            self.alertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}

extension CustomAlertView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self)
        let isPointInAlertView = alertView.frame.contains(touchPoint)

        return !isPointInAlertView
    }
}
