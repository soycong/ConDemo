//
//  HistoryViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/14/25.
//

import UIKit
import CoreData

final class HistoryViewController: UIViewController {
    // MARK: - Properties

    private let historyView: HistoryView = .init()
    private let calendarView: CalendarView = .init()
    
    private(set) var viewModel = HistoryViewModel()

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        // printAllData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        setupView()
        setupNavigationBar()
        setupAddTargets()
 
        // 테스트 코드
#if DEBUG
        // 기존 데이터 확인
        CoreDataManager.shared.printAllAnalyses()
        
        // 데이터가 없으면 테스트 데이터 생성
        let analyses = viewModel.analyses
        if analyses.isEmpty {
            print("저장된 데이터가 없어 테스트 데이터를 생성합니다.")
            _ = CoreDataManager.shared.createTestData(count: 10)
            fetchData() // 데이터 다시 불러오기
        }
#endif
        
    }

    // MARK: - Functions
    
    private func fetchData() {
        viewModel.fetchAnalyses()
        updateView()
    }
    
    private func updateView() {
        historyView.updateData(with: viewModel.analyses)
    }

    private func setDelegates() {
        historyView.delegate = self
        calendarView.delegate = self
    }

    private func setupView() {
        view = historyView
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = .none

        // x버튼 어색해서 < 버튼으로 변경
        navigationItem
            .leftBarButtonItem =
            UIBarButtonItem(image: .init(systemName: ButtonSystemIcon.backButtonImage),
                            style: .plain, target: self,
                            action: #selector(xmarkButtonTapped))
        navigationItem
            .rightBarButtonItem = UIBarButtonItem(image: .init(systemName: "person.circle"),
                                                  style: .plain, target: self,
                                                  action: #selector(profileButtonTapped))
    }
}

extension HistoryViewController {
    private func setupAddTargets() {
        historyView.calenderButton.addTarget(self, action: #selector(calendarButtonTapped),
                                             for: .touchUpInside)
    }

    @objc
    private func xmarkButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func calendarButtonTapped() {
        calendarView.show(in: historyView)
    }

//    @objc
//    private func profileButtonTapped() { }

    private func pushToSummaryViewController() {
        let summaryVC: SummaryViewController = .init()
        navigationController?.pushViewController(summaryVC, animated: true)
    }
    
    private func pushToSummaryViewController(with analysisTitle: String) {
        let summaryVC: SummaryViewController = .init()
        // 필요하다면 선택된 Analysis를 SummaryViewController에 전달
        // summaryVC.selectedAnalysis = viewModel.getAnalysis(at: analysisIndex)
        navigationController?.pushViewController(summaryVC, animated: true)
    }
}

extension HistoryViewController: HistoryViewDelegate {
    func didSelectHistory(at index: Int) {
        if let analysis = viewModel.getAnalysis(at: index),
           let title = analysis.title {
            pushToSummaryViewController(with: title)
        } else {
            pushToSummaryViewController()
        }
    }
    
    func deleteHistory(at index: Int) {
        viewModel.deleteAnalysis(at: index)
        updateView()
    }
}

extension HistoryViewController: CalendarViewDelegate {
    func calendarView(_: CalendarView, didSelectDate date: Date) {
        // 선택된 날짜로 Analysis 필터링
        viewModel.fetchAnalyses(for: date)
        updateView()
        
        // 필터링된 결과가 있으면 첫 번째 항목으로 이동
        if viewModel.hasAnalyses(),
           let analysis = viewModel.getAnalysis(at: 0),
           let title = analysis.title {
            pushToSummaryViewController(with: title)
        } else {
            // 필터링된 결과가 없으면 사용자에게 알림
            let alert = UIAlertController(
                title: "알림",
                message: "선택한 날짜에 대화 기록이 없습니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }
}

// 테스트 코드
extension HistoryViewController {
    @objc private func profileButtonTapped() {
        // 간단한 액션 시트 표시
        let actionSheet = UIAlertController(title: "개발자 메뉴", message: nil, preferredStyle: .actionSheet)
        
        // 테스트 데이터 생성 옵션
        actionSheet.addAction(UIAlertAction(title: "테스트 데이터 생성", style: .default) { _ in
            self.createTestData()
        })
        
        // 모든 데이터 삭제 옵션
        actionSheet.addAction(UIAlertAction(title: "모든 데이터 삭제", style: .destructive) { _ in
            self.deleteAllData()
        })
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(actionSheet, animated: true)
    }

    private func createTestData() {
        // 몇 개의 테스트 메시지 생성
        let messages: [MessageData] = [
            MessageData(id: UUID().uuidString, text: "안녕하세요!", isFromCurrentUser: true, timestamp: Date()),
            MessageData(id: UUID().uuidString, text: "반갑습니다!", isFromCurrentUser: false, timestamp: Date())
        ]
        
        // 테스트 Analysis 객체 여러 개 생성
        for i in 1...5 {
            let analysis = CoreDataManager.shared.createAnalysis(messages: messages)
            analysis.title = "테스트 대화 \(i)"
            analysis.level = Int32.random(in: 1...10)
            
            // 1일씩 과거의 날짜로 설정 (날짜별 필터링 테스트용)
            let daysAgo = TimeInterval(-24 * 3600 * Double(i - 1))
            analysis.date = Date().addingTimeInterval(daysAgo)
        }
        
        do {
            try CoreDataManager.shared.context.save()
            // 성공 알림
            let alert = UIAlertController(title: "성공", message: "테스트 데이터 5개 생성 완료", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            
            // 테이블 뷰 새로고침
            fetchData()
        } catch {
            // 실패 알림
            let alert = UIAlertController(title: "실패", message: "데이터 생성 오류: \(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }

    private func deleteAllData() {
        // 모든 Analysis 가져오기
        let fetchRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
        
        do {
            let analyses = try CoreDataManager.shared.context.fetch(fetchRequest)
            
            // 모든 객체 삭제
            for analysis in analyses {
                CoreDataManager.shared.context.delete(analysis)
            }
            
            try CoreDataManager.shared.context.save()
            
            // 성공 알림
            let alert = UIAlertController(title: "성공", message: "\(analyses.count)개 데이터 삭제 완료", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            
            // 테이블 뷰 새로고침
            fetchData()
        } catch {
            // 실패 알림
            let alert = UIAlertController(title: "실패", message: "데이터 삭제 오류: \(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }
    
    func printAllData() {
        let fetchRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
        
        do {
            let analyses = try CoreDataManager.shared.context.fetch(fetchRequest)
            print("---------- CoreData 내용 ----------")
            print("총 \(analyses.count)개의 분석 데이터")
            
            for (index, analysis) in analyses.enumerated() {
                print("\n[\(index + 1)] 분석 ID: \(analysis.objectID)")
                print("제목: \(analysis.title ?? "없음")")
                print("날짜: \(analysis.date?.description ?? "없음")")
                print("레벨: \(analysis.level)")
                
                // 메시지 정보도 출력
                let messageRequest: NSFetchRequest<Message> = Message.fetchRequest()
                messageRequest.predicate = NSPredicate(format: "analysis == %@", analysis)
                
                let messages = try CoreDataManager.shared.context.fetch(messageRequest)
                print("연결된 메시지: \(messages.count)개")
                
                for (msgIndex, message) in messages.enumerated() {
                    print("  메시지 \(msgIndex + 1): \(message.text ?? "없음") (\(message.isFromCurrentUser ? "사용자" : "상대방"))")
                }
            }
            print("----------------------------------")
        } catch {
            print("데이터 조회 실패: \(error)")
        }
    }
}
