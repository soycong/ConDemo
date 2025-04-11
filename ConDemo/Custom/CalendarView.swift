//
//  CalendarView.swift
//  ConDemo
//
//  Created by 이명지 on 4/10/25.
//

import UIKit

final class CalendarView: UIView {
    // MARK: - Properties

    private var isAnimating: Bool = false
    private var lastTouchTime: TimeInterval = 0
    
    private var backgroundView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        return view
    }()

    private let containerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 10
        return view
    }()
    
    private let calendarView: UICalendarView = {
        let view: UICalendarView = .init()
        view.wantsDateDecorations = true
        view.backgroundColor = .clear
        return view
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupConstratins()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarView {
    private func setupSubviews() {
        addSubview(backgroundView)
        addSubview(containerView)
        containerView.addSubview(calendarView)
    }

    private func setupConstratins() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(310)
            make.center.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}

extension CalendarView {
    func show(in superView: UIView) {
        frame = superView.bounds

        containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        containerView.alpha = 0
        backgroundView.alpha = 0

        superView.addSubview(self)

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.backgroundView.alpha = 1
            self.containerView.transform = .identity
            self.containerView.alpha = 1
        }
    }
}

extension CalendarView {
    @objc
    private func dismiss() {
        if isAnimating { return }
        
        isAnimating = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.removeFromSuperview()
            self.isAnimating = false
        })
    }
}

extension CalendarView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if isAnimating {
            return false
        }
        
        // 중복 호출 방지 (짧은 시간 내 여러 번 호출되는 것 방지)
        let currentTime = Date().timeIntervalSince1970
        if currentTime - lastTouchTime < 0.3 {
            return containerView.frame.contains(point)
        }
        lastTouchTime = currentTime
        
        // containerView 영역 내부의 터치인지 확인
        if containerView.frame.contains(point) {
            // containerView 내부 터치는 처리 허용
            return true
        } else {
            // backgroundView 영역 터치는 메인 스레드에서 약간의 지연 후 dismiss 호출
            DispatchQueue.main.async { [weak self] in
                self?.dismiss()
            }
            // 터치 이벤트를 처리했으므로 true 반환
            return true
        }
    }
}
