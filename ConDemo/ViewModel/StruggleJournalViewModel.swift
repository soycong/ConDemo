//
//  StruggleJournalViewModel.swift
//  ConDemo
//
//  Created by seohuibaek on 4/17/25.
//

import Foundation
import CoreData
import UIKit

class StruggleJournalViewModel {
    // MARK: - Properties
    
    private var analysisTitle: String
    private var analysis: Analysis?
    
    // 트러블로그 데이터
    var logContent: String = ""
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
            
            if let analysisSet = analysis.analysislog as? Set<Log> {
                if let log = analysisSet.first {
                    self.logContent = log.contents ?? "내용 없음"
                    
                    if let date = log.date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy.MM.dd a HH:mm"
                        formatter.locale = Locale(identifier: "ko_KR")
                        self.date = formatter.string(from: date)
                    }
                } else {
                    print("분석에 연결된 로그가 없습니다.")
                }
            }
            
            print()
            print(logContent)
            print()
            
        } catch {
            print("분석 결과 조회 실패: \(error)")
        }
    }
    
    // 수정된 내용 저장하기
    func saveLog(content: String) -> Bool {
        guard let analysis = analysis else {
            print("Analysis 객체가 없습니다.")
            return false
        }
        
        let context = CoreDataManager.shared.context
        
        // 이미 Log 객체들이 있는지 확인하고 처리
        if let logSet = analysis.analysislog as? Set<Log>, let existingLog = logSet.first {
            // 기존 Log 업데이트
            existingLog.contents = content
            existingLog.date = Date()
        } else {
            // 새 Log 생성
            let newLog = Log(context: context)
            newLog.contents = content
            newLog.date = Date()

            analysis.addToAnalysislog(newLog)
        }
        
        do {
            try context.save()
            self.logContent = content
            
            // 날짜 업데이트
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd a HH:mm"
            formatter.locale = Locale(identifier: "ko_KR")
            self.date = formatter.string(from: Date())
            
            return true
        } catch {
            print("트러블로그 저장 실패: \(error)")
            return false
        }
    }
}
