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
    private let stopwatch: Stopwatch = .init()

    private var originalBrightness: CGFloat = 0
    private var brightnessTimer: Timer?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view = recordingMainView
        originalBrightness = UIScreen.main.brightness
        setupNavigationBar()
        setupAddTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCurrentTime()
        setupStopwatch()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBrightnessTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetBrightnessTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if recordingMainView.dimLayer.isHidden {
            self.recordingMainView.recordButton.layer.borderColor = UIColor.label.resolvedColor(with: self.traitCollection).cgColor
        } else {
            self.recordingMainView.recordButton.layer.borderColor = UIColor.systemBlue.resolvedColor(with: self.traitCollection).cgColor
        }
        // dimLayer가 있을 때 -> 버튼 무조건 파란색
        // dimLayer가 없을 때 -> .label
    }

    // MARK: - Overridden Functions

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.recordingMainView.dimLayer.alpha = 0
        }, completion: { [weak self] _ in
            self?.recordingMainView.dimLayer.isHidden = true
        })

        setupBrightnessTimer()
    }

    // MARK: - Functions

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

    private func setupStopwatch() {
        stopwatch.delegate = self
        stopwatch.reset()
        stopwatch.start()
        updateRecordButtonImage()
    }

    private func setupAddTargets() {
        recordingMainView.recordButton.addTarget(self, action: #selector(recordButtonTapped),
                                                 for: .touchUpInside)
    }

    private func setupCurrentTime() {
        recordingMainView.dateLabel.text = Date().toKoreaFormat().description
    }

    private func setupBrightnessTimer() {
        resetBrightnessTimer()

        brightnessTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false,
                                               block: { [weak self] _ in
                                                   self?.reduceBrightness()
                                               })
    }

    private func resetBrightnessTimer() {
        brightnessTimer?.invalidate()
        brightnessTimer = nil

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.recordingMainView.dimLayer.alpha = 0
            self?.recordingMainView.recordButton.layer.borderColor = UIColor.label.resolvedColor(with: self!.traitCollection).cgColor
            self?.recordingMainView.recordButton.tintColor = .label
        }, completion: { [weak self] _ in
            self?.recordingMainView.dimLayer.isHidden = true
        })
    }

    private func reduceBrightness() {
        recordingMainView.dimLayer.alpha = 0
        recordingMainView.dimLayer.isHidden = false

        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.recordingMainView.dimLayer.alpha = 0.6
            self?.recordingMainView.recordButton.layer.borderColor = UIColor.systemBlue.resolvedColor(with: self!.traitCollection).cgColor
            self?.recordingMainView.recordButton.tintColor = .systemBlue
        }
    }

    @objc
    private func backButtonTapped() {
        showAlert(title: "녹음을 중단하시겠습니까?") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    @objc
    private func calendarButtonTapped() { }

    @objc
    private func profileButtonTapped() { }

    @objc
    private func recordButtonTapped() {
        stopwatch.toggle()
        updateRecordButtonImage()
    }

    private func updateRecordButtonImage() {
        let image = stopwatch
            .isRunning ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill")
        recordingMainView.recordButton.setImage(image, for: .normal)
    }
}

extension RecordingMainViewController: StopwatchDelegate {
    func stopwatchDidUpdate(_: Stopwatch, elapsedTime: TimeInterval) {
        recordingMainView.timeLabel.text = elapsedTime.formatTime()
    }
}

extension RecordingMainViewController {
    func showAlert(title: String, completion: @escaping () -> Void) {
        let alert: UIAlertController = .init(title: title,
                                             message: nil,
                                             preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { _ in
            completion()
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
