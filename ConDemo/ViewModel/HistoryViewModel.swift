//
//  HistoryViewModel.swift
//  ConDemo
//
//  Created by seohuibaek on 4/17/25.
//

import Foundation
import CoreData

final class HistoryViewModel {
    
    private(set) var analyses: [Analysis] = []
    
    func fetchAnalyses() {
        analyses = CoreDataManager.shared.fetchAllAnalyses()
    }
    
    func fetchAnalyses(for date: Date) {
        analyses = CoreDataManager.shared.fetchAnalyses(for: date)
    }
    
    func deleteAnalysis(at index: Int) {
        guard index < analyses.count else { return }
        
        let analysisToDelete = analyses[index]
        CoreDataManager.shared.deleteAnalysis(analysisToDelete)
        analyses.remove(at: index)
    }
    
    func getAnalysisCount() -> Int {
        return analyses.count
    }
    
    func getAnalysis(at index: Int) -> Analysis? {
        guard index < analyses.count else { return nil }
        return analyses[index]
    }
    
    func hasAnalyses() -> Bool {
        return analyses.count > 0
    }
    
    // 레벨에 따른 이미지 이름 반환
    func getEmotionImageName(for level: Int32) -> String {
        return "level\(level)"
    }
    
    // 날짜 포맷팅
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    // 타이틀 포맷팅
//    func formatTitle(_ title: String?, level: Int32) -> String {
//        guard let title = title, !title.isEmpty else {
//            return "대화 분석 | 매운맛 \(level)"
//        }
//        
//        switch level {
//        case 1 ... 5:
//            return "\(title) | 순한맛 \(level)단계"
//        case 6 ... 10:
//            return "\(title) | 순한맛 \(level)단계"
//        default:
//            return "분석이 어렵습니다."
//        }
//    }
}

extension HistoryViewModel {
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
