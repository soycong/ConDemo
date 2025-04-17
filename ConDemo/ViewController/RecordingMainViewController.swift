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

    private var sheetViewController: VoiceNoteViewController = .init()
    private var didPresentSheet = false

    private let calendarView: CalendarView = .init()

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
        setupDelegates()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !viewModel.hasStartedRecordingOnce {
            viewModel.startRecording()
            viewModel.hasStartedRecordingOnce = true
            setupStopwatch()
            setupCurrentTime()
        }

        if viewModel.isRecording {
            setupBrightnessTimer()
        } else {
            resetBrightnessTimer()
        }

        if !didPresentSheet {
            presentAsBottomSheet(sheetViewController)
            didPresentSheet = true
        }
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if viewModel.isRecording {
//            setupBrightnessTimer()
//        }
//    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetBrightnessTimer()

        sheetViewController.dismiss(animated: true)
        didPresentSheet = false
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

    private func setupDelegates() {
        stopwatch.delegate = self
        calendarView.delegate = self
    }
}

extension RecordingMainViewController {
    private func setupBrightnessTimer() {
        resetBrightnessTimer()

        guard !didPresentSheet else {
            return
        }

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

    /// 일시정지할 때는 dimLayer 빼기
    private func reduceBrightness() {
        guard viewModel.isRecording || !didPresentSheet else {
            return
        }

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
                let resultPath = self?.viewModel.stopRecording()
                self?.navigationController?.popViewController(animated: true)
            }
    }

    @objc
    private func calendarButtonTapped() {
        resetBrightnessTimer()
        
        let datesToMark = [
            Date(), // 오늘
            Calendar.current.date(byAdding: .day, value: 1, to: Date())!, // 내일
            Calendar.current.date(byAdding: .day, value: 3, to: Date())!  // 5일 후
        ]
        
        calendarView.markDates(datesToMark)
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
                let resultPath = self?.viewModel.stopRecording()
                self?.navigationController?.popViewController(animated: true)
            }
    }
}

extension RecordingMainViewController {
    @objc
    private func completeButtonTapped() {
        resetBrightnessTimer()
        
        // 비동기 작업을 Task로 래핑
        Task {
            do {
                let customAlert = CustomAlertView.init()
                
                // 알림창 표시
                await MainActor.run {
                    customAlert.show(in: recordingMainView, message: "녹음을 종료합니다") { [weak self] in
                        guard let self = self else { return }
                        
                        // 녹음 중지 로직
                        if self.viewModel.isRecording {
                            self.viewModel.pauseRecording()
                            self.stopwatch.pause()
                            self.updateRecordButtonImage()
                        }
                        
                        // 녹음 파일 저장 및 경로 얻기
                        let resultPath = self.viewModel.stopRecording()
                        navigationController?.pushViewController(SummaryViewController(), animated: true)
                        
                        // 비동기로 트랜스크립션/챗지피티 분석 시작
                        Task {
                            do {
                                // 1. 트랜스크립션 요청
                                let messagesData = try await TranscribeManager.shared.transcribeAudioFile(at: resultPath)
                                
//                                // 분석 결과 저장
//                                await MainActor.run {
//                                    print("분석 완료: \(messagesData.count)개의 메시지가 생성되었습니다")
//                                    
//                                    // 분석 결과 저장 및 표시
//                                    if !messagesData.isEmpty {
//                                        // CoreData에 저장
//                                        let coreDataManager = CoreDataManager.shared
//                                        let analysis = coreDataManager.createAnalysis(messages: messagesData)
//                                        
//                                        // 야매 코드
//                                        CoreDataManager.title = analysis.title!
//                                        
//                                        // 메시지 출력 (디버깅용)
//                                        messagesData.forEach {
//                                            print($0.text)
//                                        }
//                                    } else {
//                                        print("분석 결과가 없습니다")
//                                    }
//                                }
                                
                                // 2. chatGPT 분석 요청
                                await ChatGPTManager.shared.analyzeTranscript(messages: messagesData) { result in
                                    DispatchQueue.main.async {
                                        switch result {
                                        case .success(let analysis):
                                            // TODO: - 추후 변경
                                            print(analysis)
                                        case .failure(let error):
                                            print("ChatGPT 분석 실패: \(error)")
                                        }
                                    }
                                }
                            } catch {
                                // 에러 처리
                                await MainActor.run {
                                    print("음성 분석 실패: \(error)")
                                    
                                    // 에러 메시지 표시
                                    let errorAlert = UIAlertController(
                                        title: "음성 분석 실패",
                                        message: "음성 분석 중 오류가 발생했습니다: \(error.localizedDescription)",
                                        preferredStyle: .alert
                                    )
                                    errorAlert.addAction(UIAlertAction(title: "확인", style: .default))
                                    self.present(errorAlert, animated: true)
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Failed to show alert: \(error)")
            }
        }
    }
}


extension RecordingMainViewController: StopwatchDelegate {
    func stopwatchDidUpdate(_: Stopwatch, elapsedTime: TimeInterval) {
        recordingMainView.timeLabel.text = elapsedTime.formatTime()
    }
}

extension RecordingMainViewController {
    func presentAsBottomSheet(_ viewController: UIViewController) {
        // 시트 프레젠테이션 컨트롤러 구성
        let customIdentifier = UISheetPresentationController.Detent.Identifier("custom20")
        let customDetent = UISheetPresentationController.Detent
            .custom(identifier: customIdentifier) { _ in
                20 // 원하는 높이
            }

        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [customDetent,
                             .medium(), // 화면 중간 높이까지
                             .large(), // 전체 화면 높이
            ]

            sheet.delegate = self
            // 사용자가 시트를 끌어올릴 수 있도록 설정
            sheet.prefersGrabberVisible = true

            // 시작 시 어떤 높이로 표시할지 설정
            sheet.selectedDetentIdentifier = .some(customIdentifier)

            // 드래그 중에 아래 뷰가 어두워지지 않도록 설정
            sheet.largestUndimmedDetentIdentifier = .large
        }

        present(viewController, animated: true)
    }
}

extension RecordingMainViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        if sheetPresentationController.selectedDetentIdentifier == UISheetPresentationController
            .Detent.Identifier("custom20") {
            didPresentSheet = false

            if viewModel.isRecording {
                setupBrightnessTimer()
            }
        } else {
            didPresentSheet = true

            resetBrightnessTimer()
        }
    }
}

extension RecordingMainViewController: CalendarViewDelegate {
    private func pushToSummaryViewController() {
        let summaryVC: SummaryViewController = .init()
        navigationController?.pushViewController(summaryVC, animated: true)
    }

    func calendarView(_: CalendarView, didSelectDate _: Date) {
        pushToSummaryViewController()
    }
}
