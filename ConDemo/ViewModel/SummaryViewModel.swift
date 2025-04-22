//
//  SummaryViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/17/25.
//

import Foundation
import CoreData
import UIKit

final class SummaryViewModel {
    // MARK: - Properties
    
    private var analysisTitle: String
    var analysis: Analysis?
    
    // 뷰에 표시할 데이터
    var title: String = ""
    var date: String = ""
    var contents: [String] = []
    var emotionLevel: Int = 1
    
    // MARK: - Lifecycle
    
    init(analysisTitle: String) {
        self.analysisTitle = analysisTitle
        fetchAnalysis()
        setupViewData()
    }
    
    // MARK: - Functions
    
    /// CoreData에서 분석 결과 가져오기
    private func fetchAnalysis() {
        // 1. 해당 타이틀을 가진 Analysis 찾기
        let context = CoreDataManager.shared.context
        let analysisRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
        analysisRequest.predicate = NSPredicate(format: "title == %@", analysisTitle)
        
        do {
            // 2. Analysis 객체 가져오기
            let analyses = try context.fetch(analysisRequest)
            
            // 분석 결과가 없으면 기본값 유지
            guard let analysis = analyses.first else {
                print("해당 타이틀(\(analysisTitle))을 가진 분석 결과가 없습니다.")
                return
            }
            
            // 3. 가져온 Analysis 객체 저장
            self.analysis = analysis
            
        } catch {
            print("분석 결과 조회 실패: \(error)")
        }
    }
    
    /// Analysis 객체에서 뷰에 표시할 데이터 설정
    private func setupViewData() {
        guard let analysis = analysis else { return }
        
        // 타이틀 설정
        title = analysis.title ?? "제목 없음"
        
        // 날짜 설정 (포맷팅)
        if let date = analysis.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd a HH:mm"
            formatter.locale = Locale(identifier: "ko_KR")
            self.date = formatter.string(from: date)
        }
        
        // 내용 설정 (쟁점별로 분리)
        if let contents = analysis.contents {
            // 줄바꿈으로 분리하여 배열에 저장
            self.contents = contents.components(separatedBy: "\n").filter { !$0.isEmpty }
        }
        
        // 감정 레벨 설정
        emotionLevel = Int(analysis.level)
    }
    
    func updateWithAnalysis(_ analysis: Analysis) {
        self.analysis = analysis
        if let title = analysis.title {
            self.analysisTitle = title
        }
        setupViewData()
    }
}

extension SummaryViewModel {
    func fetchAnalysisAvailableDates() -> [Date] {
        // CoreData에서 모든 Analysis 객체의 날짜 가져오기
        let fetchRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
        fetchRequest.propertiesToFetch = ["date"] // 날짜만 가져오기
        
        do {
            let analyses = try CoreDataManager.shared.context.fetch(fetchRequest)
            
            // nil이 아닌 날짜만 반환
            return analyses.compactMap { $0.date }
        } catch {
            print("분석 날짜 조회 실패: \(error)")
            return []
        }
    }
    
    //    func fetchAnalysisForDate(_ date: Date) -> Analysis? {
    //        let calendar = Calendar.current
    //
    //        // 선택된 날짜의 시작과 끝 시간 계산
    //        let startOfDay = calendar.startOfDay(for: date)
    //        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
    //
    //        // 해당 날짜 범위에 있는 Analysis 찾기
    //        let fetchRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
    //        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
    //        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    //
    //        do {
    //            let analyses = try CoreDataManager.shared.context.fetch(fetchRequest)
    //            return analyses.first
    //        } catch {
    //            print("분석 데이터 조회 실패: \(error)")
    //            return nil
    //        }
    //    }
    
    // 특정 날짜의 모든 분석 데이터 가져오기
    func fetchAllAnalysesForDate(_ date: Date) -> [Analysis] {
        let calendar = Calendar.current
        
        // 선택된 날짜의 시작과 끝 시간 계산
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // 해당 날짜 범위에 있는 모든 Analysis 찾기
        let fetchRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let analyses = try CoreDataManager.shared.context.fetch(fetchRequest)
            return analyses
        } catch {
            print("분석 데이터 조회 실패: \(error)")
            return []
        }
    }
}
