//
//  RecordingMainViewController.swift
//  ConDemo
//
//  Created by 이명지 on 4/9/25.
//

import UIKit

final class RecordingMainViewController: UIViewController {
    // MARK: - Properties

    private let viewModel: RecordingMainViewModel

    private let recordingMainView: RecordingMainView = .init()
    private let stopwatch: Stopwatch = .init()

    private var originalBrightness: CGFloat = 0
    private var brightnessTimer: Timer?

    // MARK: - Lifecycle

    init(_ viewModel: RecordingMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecordingMainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view = recordingMainView
        originalBrightness = UIScreen.main.brightness
        setupNavigationBar()
        setupAddTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startRecording()
        setupCurrentTime()
        setupStopwatch()
        
        if viewModel.isRecording {
            setupBrightnessTimer()
        } else {
            resetBrightnessTimer()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.isRecording {
            setupBrightnessTimer()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetBrightnessTimer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if recordingMainView.dimLayer.isHidden {
            recordingMainView.recordButton.layer.borderColor = UIColor.label
                .resolvedColor(with: traitCollection).cgColor
        } else {
            recordingMainView.recordButton.layer.borderColor = UIColor.systemBlue
                .resolvedColor(with: traitCollection).cgColor
        }
        // dimLayer가 있을 때 -> 버튼 무조건 파란색
        // dimLayer가 없을 때 -> .label
    }
}

extension RecordingMainViewController {
    // MARK: - Overridden Functions

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        if !viewModel.isRecording {
            resetBrightnessTimer()
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.recordingMainView.dimLayer.alpha = 0
        }, completion: { [weak self] _ in
            self?.recordingMainView.dimLayer.isHidden = true
        })

        setupBrightnessTimer()
    }
}

extension RecordingMainViewController {
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
        recordingMainView.saveButton.addTarget(self, action: #selector(saveButtonTapped),
                                               for: .touchUpInside)
        recordingMainView.completeButton.addTarget(self, action: #selector(completeButtonTapped),
                                                   for: .touchUpInside)
    }

    private func setupCurrentTime() {
        recordingMainView.dateLabel.text = Date().toKoreaFormat().description
    }
}

extension RecordingMainViewController {
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
            self?.recordingMainView.recordButton.layer.borderColor = UIColor.label
                .resolvedColor(with: self!.traitCollection).cgColor
            self?.recordingMainView.recordButton.tintColor = .label
        }, completion: { [weak self] _ in
            self?.recordingMainView.dimLayer.isHidden = true
        })
    }

    
    // 일시정지할 때는 dimLayer 빼기
    private func reduceBrightness() {
        guard viewModel.isRecording else { return }
        
        recordingMainView.dimLayer.alpha = 0
        recordingMainView.dimLayer.isHidden = false

        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.recordingMainView.dimLayer.alpha = 0.8
            self?.recordingMainView.recordButton.layer.borderColor = UIColor.systemBlue
                .resolvedColor(with: self!.traitCollection).cgColor
            self?.recordingMainView.recordButton.tintColor = .systemBlue
        }
    }
}

extension RecordingMainViewController {
    @objc
    private func backButtonTapped() {
        resetBrightnessTimer()
        
        let customAlert: CustomAlertView = .init()
        customAlert
            .show(in: recordingMainView, message: "녹음을 중단하시겠습니까?") { [weak self] in
                self?.viewModel.stopRecording()
                self?.navigationController?.popViewController(animated: true)
            }
    }

    @objc
    private func calendarButtonTapped() {
        resetBrightnessTimer()
        
        let calendarView: CalendarView = .init()
        calendarView.show(in: recordingMainView)
    }

    @objc
    private func profileButtonTapped() {
        resetBrightnessTimer()
        
    }
}

extension RecordingMainViewController {
    @objc
    private func recordButtonTapped() {
        viewModel.recordToggle()
        stopwatch.toggle()
        updateRecordButtonImage()
        
        if viewModel.isRecording {
            setupBrightnessTimer()
        } else {
            resetBrightnessTimer()
        }
    }

    private func updateRecordButtonImage() {
        let image = stopwatch
            .isRunning ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill")
        recordingMainView.recordButton.setImage(image, for: .normal)
    }

    @objc
    private func saveButtonTapped() {
        resetBrightnessTimer()
        
        let customAlert: CustomAlertView = .init()
        customAlert
            .show(in: recordingMainView, message: "녹음을 시작한 부분부터\n현재까지 저장합니다") { [weak self] in
                self?.viewModel.stopRecording()
                self?.navigationController?.popViewController(animated: true)
            }
    }

    @objc
    private func completeButtonTapped() {
        resetBrightnessTimer()
        
        let customAlert: CustomAlertView = .init()
        customAlert
            .show(in: recordingMainView, message: "녹음을 종료합니다") { [weak self] in
                self?.viewModel.stopRecording()
                self?.navigationController?.popViewController(animated: true)
            }
    }
}

extension RecordingMainViewController: StopwatchDelegate {
    func stopwatchDidUpdate(_: Stopwatch, elapsedTime: TimeInterval) {
        recordingMainView.timeLabel.text = elapsedTime.formatTime()
    }
}
