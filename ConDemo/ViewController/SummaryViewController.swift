//
//  SummaryViewController.swift
//  ConDemo
//
//  Created by 이명지 on 4/11/25.
//

import UIKit
import CoreData

final class SummaryViewController: UIViewController {
    // MARK: - Properties
    
    private var analysisTitle: String
    private let summaryView: SummaryView = .init()
    private var viewModel: SummaryViewModel
    private let calendarView: CalendarView = .init()
    
    // MARK: - 페이징 관련 추가 속성
    private var allAnalyses: [Analysis] = []
    private var currentAnalysisIndex: Int = 0
    
    init(analysisTitle: String, isSummaryView: Bool = true) {
        self.analysisTitle = analysisTitle
        self.viewModel = SummaryViewModel(analysisTitle: analysisTitle)
        super.init(nibName: nil, bundle: nil)
        setupNavigationBar(isSummaryView: isSummaryView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupAddTargets()
        setupDelegates()
        setupGestureRecognizers()
        updateViewWithCurrentAnalysis()
        setupViewModels()
    }
}

extension SummaryViewController {
    private func setupView() {
        if let analysis = viewModel.analysis {
            summaryView.setupText(analysis: analysis)
        }
        view = summaryView
    }
    
    private func setupNavigationBar(isSummaryView: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        // navigationController?.navigationBar.tintColor = .label
        navigationItem.title = .none
        
        if isSummaryView {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: .init(systemName: ButtonSystemIcon.cancelButtonImage),
                                                               style: .plain, target: self,
                                                               action: #selector(cancelButtonTapped))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: .init(systemName: ButtonSystemIcon.backButtonImage),
                                                               style: .plain, target: self,
                                                               action: #selector(backButtonTapped))
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: .init(systemName: "person.circle"),
                                                              style: .plain, target: self,
                                                              action: #selector(profileButtonTapped)),
                                              UIBarButtonItem(image: .init(systemName: "calendar"), style: .plain, target: self,
                                                              action: #selector(calendarButtonTapped))]
    }
    
    private func setupAddTargets() {
        [summaryView.factCheckButton,
         summaryView.logButton,
         summaryView.pollButton,
         summaryView.summaryButton].forEach {
            $0.addTarget(self, action: #selector(navigateToVC), for: .touchUpInside)
        }
        
        summaryView.analysisExpandButton.addTarget(self, action: #selector(toggleAnalysisSection), for: .touchUpInside)
    }
    
    func setAnalyses(_ analyses: [Analysis], initialIndex: Int = 0) {
        allAnalyses = analyses
        currentAnalysisIndex = min(initialIndex, analyses.count - 1)
        
        if isViewLoaded {
            updateViewWithCurrentAnalysis()
        }
    }
    
    private func setupDelegates() {
        calendarView.delegate = self
    }
    
    private func setupGestureRecognizers() {
        // 스와이프 제스처 설정
        summaryView.leftSwipeGestureRecognizer.addTarget(self, action: #selector(handleLeftSwipe))
        summaryView.rightSwipeGestureRecognizer.addTarget(self, action: #selector(handleRightSwipe))
        
        // 페이지 컨트롤 액션 설정
        summaryView.pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
    }
    
    // 현재 선택된 Analysis로 뷰 업데이트
    private func updateViewWithCurrentAnalysis() {
        // 데이터가 없으면 종료
        guard !allAnalyses.isEmpty, currentAnalysisIndex < allAnalyses.count else { return }
        
        // 선택된 Analysis 가져오기
        let currentAnalysis = allAnalyses[currentAnalysisIndex]
        
        if let title = currentAnalysis.title {
            viewModel = SummaryViewModel(analysisTitle: title)
        }
        
        // 뷰 업데이트
        summaryView.setupText(analysis: currentAnalysis)
        
        // 페이지 컨트롤 업데이트
        summaryView.setupPageControl(totalPages: allAnalyses.count, currentPage: currentAnalysisIndex)
        
        // 여러 페이지가 있는 경우
        if allAnalyses.count > 1 {
            navigationItem.title = "\(currentAnalysisIndex + 1)/\(allAnalyses.count)"
        }
    }
    
    @objc private func handleLeftSwipe() {
        // 이미 마지막 페이지면 무시
        guard currentAnalysisIndex < allAnalyses.count - 1 else { return }
        
        // 다음 페이지로 이동
        currentAnalysisIndex += 1
        summaryView.pageControl.currentPage = currentAnalysisIndex
        
        // 페이지 전환 애니메이션과 함께 뷰 업데이트
        let combinedOptions: UIView.AnimationOptions = [.transitionCrossDissolve, .curveEaseInOut]
        summaryView.animatePageTransition(direction: combinedOptions) {
            self.updateViewWithCurrentAnalysis()
        }
    }
    
    @objc private func handleRightSwipe() {
        // 이미 첫 페이지면 무시
        guard currentAnalysisIndex > 0 else { return }
        
        // 이전 페이지로 이동
        currentAnalysisIndex -= 1
        summaryView.pageControl.currentPage = currentAnalysisIndex
        
        // 페이지 전환 애니메이션과 함께 뷰 업데이트
        let combinedOptions: UIView.AnimationOptions = [.transitionCrossDissolve, .curveEaseInOut]
        summaryView.animatePageTransition(direction: combinedOptions) {
            self.updateViewWithCurrentAnalysis()
        }
    }
    
    @objc private func pageControlValueChanged() {
        // 현재 페이지와 같으면 무시
        let newPage = summaryView.pageControl.currentPage
        guard newPage != currentAnalysisIndex else { return }
        
        let direction: UIView.AnimationOptions = newPage > currentAnalysisIndex
        ? .curveEaseInOut
        : .curveEaseInOut
        
        // 페이지 인덱스 업데이트
        currentAnalysisIndex = newPage
        
        // 페이지 전환 애니메이션과 함께 뷰 업데이트
        summaryView.animatePageTransition(direction: direction) {
            self.updateViewWithCurrentAnalysis()
        }
    }
    
    @objc
    private func toggleAnalysisSection() {
        summaryView.isAnalysisExpanded.toggle()
        
        let imageName = summaryView.isAnalysisExpanded ? "chevron.up" : "chevron.down"
        summaryView.analysisExpandButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            
            [
                self.summaryView.speakingPieChartView,
                self.summaryView.consistencyChartView,
                self.summaryView.factualAccuracyChartView,
                self.summaryView.positiveWordsBarChartView,
                self.summaryView.negativeWordsBarChartView
            ].forEach {
                $0.isHidden = !self.summaryView.isAnalysisExpanded
            }
            
            if self.summaryView.isAnalysisExpanded {
                // 펼쳐진 상태일 때 페이지 컨트롤, 버튼 스택뷰 위치
                self.summaryView.pageControl.snp.remakeConstraints { make in
                    make.bottom.equalTo(self.summaryView.buttonStackView.snp.top).offset(-15)
                    make.centerX.equalToSuperview()
                    make.height.equalTo(30)
                }
                
                self.summaryView.buttonStackView.snp.remakeConstraints { make in
                    make.top.equalTo(self.summaryView.negativeWordsBarChartView.snp.bottom).offset(30)
                    make.horizontalEdges.equalToSuperview().inset(25)
                    make.bottom.equalToSuperview().offset(-20)
                }
            } else {
                // 접힌 상태일 때 페이지 컨트롤, 버튼 스택뷰 위치
                self.summaryView.pageControl.snp.remakeConstraints { make in
                    make.bottom.equalTo(self.summaryView.buttonStackView.snp.top).offset(-15)
                    make.centerX.equalToSuperview()
                    make.height.equalTo(30)
                }
                
                self.summaryView.buttonStackView.snp.remakeConstraints { make in
                    make.top.equalTo(self.summaryView.analysisLabel.snp.bottom).offset(37)
                    make.horizontalEdges.equalToSuperview().inset(25)
                    make.bottom.equalToSuperview().offset(-20)
                }
            }
            
            self.summaryView.layoutIfNeeded()
        }
    }
}

extension SummaryViewController {
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func cancelButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    private func calendarButtonTapped() {
        // CoreData에서 분석 데이터가 있는 날짜 가져오기
        /// 나중에 calendarViewMode l만들기
        let analysisAvailableDates = viewModel.fetchAnalysisAvailableDates()
        
        // 가져온 날짜들만 달력에 마킹
        calendarView.markDates(analysisAvailableDates)
        calendarView.show(in: summaryView)
    }
    
    @objc
    private func profileButtonTapped() { }
}

extension SummaryViewController {
    @objc
    func navigateToVC(_ sender: UIButton) {
        let destinationVC: UIViewController

        switch sender.tag {
        case 1:
            destinationVC = MessageViewController(analysisTitle: analysisTitle)
        case 2:
            destinationVC = StruggleJournalViewController(analysisTitle: analysisTitle)
        case 3:
            destinationVC = PollRecommendViewController(analysisTitle: analysisTitle)
        case 4:
            destinationVC = SummaryEditViewController(analysisTitle: analysisTitle)
        default:
            return
        }

        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension SummaryViewController: CalendarViewDelegate {
    func calendarView(_: CalendarView, didSelectDate selectedDate: Date) {
        // 해당 날짜의 모든 분석 데이터 가져오기
        let analysesForDate = viewModel.fetchAllAnalysesForDate(selectedDate)
        
        if analysesForDate.isEmpty {
            // 분석 데이터가 없을 경우 알림
            let alert = UIAlertController(
                title: "알림",
                message: "선택한 날짜에 분석 데이터가 없습니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        } else {
            // 첫 번째 분석 데이터의 타이틀로 SummaryViewController 생성
            if let firstAnalysis = analysesForDate.first, let title = firstAnalysis.title {
                let summaryVC = SummaryViewController(analysisTitle: title, isSummaryView: false)
                
                // 모든 분석 데이터를 전달
                summaryVC.setAnalyses(analysesForDate)
                
                navigationController?.pushViewController(summaryVC, animated: true)
            }
        }
    }
}

extension SummaryViewController {
    private func setupViewModels() {
        let analysis = viewModel.analysis
        
        let speakingViewModel = PieChartViewModel(pieData: analysis?.analysisdetailtranscript?.speakingTime as! SpeakingTime)
        summaryView.speakingPieChartView.configure(with: speakingViewModel)
        
        let barData = analysis?.analysisdetailtranscript?.sentimentAnalysis as! SentimentAnalysis
        let positiveViewModel = BarChartViewModel(barData: barData, title: "긍정적인 단어를 쓴 비율", isPositive: true)
        summaryView.positiveWordsBarChartView.configure(with: positiveViewModel)
        
        let negativeViewModel = BarChartViewModel(barData: barData, title: "부정적인 단어를 쓴 비율", isPositive: false)
        summaryView.negativeWordsBarChartView.configure(with: negativeViewModel)
        
        let consistency = analysis?.analysisdetailtranscript?.consistency as! Consistency
        let consistencyViewModel = DotRatingViewModel(
            title: "주장의 일관성",
            consistency: consistency,
            ratingLabels: ["궤변", "무슨 말이야?", "계속 해봐", "맞는 말이네", "입만 살았네"]
        )
        summaryView.consistencyChartView.configure(with: consistencyViewModel)
        
        let factualAccuracy = analysis?.analysisdetailtranscript?.factualAccuracy as! FactualAccuracy
        let factualAccuracyViewModel = DotRatingViewModel(
            title: "사실 관계의 정확성",
            factualAccuracy: factualAccuracy,
            ratingLabels: ["벌구", "뇌피셜", "반맞반틀", "믿고갑니다", "아멘"]
        )
        summaryView.factualAccuracyChartView.configure(with: factualAccuracyViewModel)
    }
}
