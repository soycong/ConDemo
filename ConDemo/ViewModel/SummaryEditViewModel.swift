//
//  SummaryEditViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/17/25.
//

import Foundation
import CoreData
import UIKit

class SummaryEditViewModel {
    // MARK: - Properties
    
    private var analysisTitle: String
    private var analysis: Analysis?
    
    // Summary 데이터
    var summaryTitle: String = ""
    var summaryContent: String = ""
    var date: String = ""
    
    // MARK: - Lifecycle
    
    init(analysisTitle: String) {
        self.analysisTitle = analysisTitle
        fetchAnalysis()
    }
    
    // MARK: - Functions
    
    /// CoreData에서 Analysis 객체 가져오기
    private func fetchAnalysis() {
        let context = CoreDataManager.shared.context
        let analysisRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
        analysisRequest.predicate = NSPredicate(format: "title == %@", analysisTitle)
        
        do {
            let analyses = try context.fetch(analysisRequest)
            
            guard let analysis = analyses.first else {
                print("해당 타이틀(\(analysisTitle))을 가진 분석 결과가 없습니다.")
                return
            }
            
            self.analysis = analysis
            
            // Analysis에서 Summary 데이터 추출
            if let analysisSet = analysis.analysissummary as? Set<Summary>, let summary = analysisSet.first {
                self.summaryTitle = summary.title ?? "제목 없음"
                self.summaryContent = summary.contents ?? "내용 없음"
                
                // 날짜 설정
                if let date = summary.date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy.MM.dd a HH:mm"
                    formatter.locale = Locale(identifier: "ko_KR")
                    self.date = formatter.string(from: date)
                }
            }
            
        } catch {
            print("분석 결과 조회 실패: \(error)")
        }
    }
    
    /// 수정된 내용 저장하기
    func saveSummary(content: String) -> Bool {
        guard let analysis = analysis,
              let summarySet = analysis.analysissummary as? Set<Summary>,
              let summary = summarySet.first else {
            return false
        }
        
        let context = CoreDataManager.shared.context
        
        // 내용 업데이트
        summary.contents = content
        summary.date = Date() // 수정 시간 업데이트
        
        do {
            try context.save()
            self.summaryContent = content
            return true
        } catch {
            print("요약 저장 실패: \(error)")
            return false
        }
    }
}
