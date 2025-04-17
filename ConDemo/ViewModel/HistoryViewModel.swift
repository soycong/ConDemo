//
//  HistoryViewModel.swift
//  ConDemo
//
//  Created by seohuibaek on 4/17/25.
//

import Foundation

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

