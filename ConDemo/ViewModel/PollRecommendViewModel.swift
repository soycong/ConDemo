//
//  PollRecommendViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/17/25.
//

import Foundation
import CoreData
import UIKit

class PollRecommendViewModel {
    // MARK: - Properties
    
    private var analysisTitle: String
    private var analysis: Analysis?
    
    // Poll 데이터
    var polls: [Poll] = []
    var pollContents: [PollContent] = []
    var date: String = ""
    
    // MARK: - Lifecycle
    
    init(analysisTitle: String) {
        self.analysisTitle = analysisTitle
        fetchAnalysis()
        setupPollContents()
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
            
            // NSSet을 [Poll]로 변환하는 부분 수정
            if let pollsSet = analysis.analysispolls as? Set<Poll> {
                self.polls = Array(pollsSet)
                
                // 날짜 설정
                if let poll = pollsSet.first {
                    if let date = poll.date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy.MM.dd a HH:mm"
                        formatter.locale = Locale(identifier: "ko_KR")
                        self.date = formatter.string(from: date)
                    }
                }
            }
            
        } catch {
            print("분석 결과 조회 실패: \(error)")
        }
    }
    
    /// Poll 객체를 PollContent 객체로 변환
    private func setupPollContents() {
        pollContents = []
        
        for poll in polls {
            // PollContent의 기존 구조체 형식에 맞게 변환
            let title = poll.title ?? "Poll"
            let body = poll.contents ?? "내용 없음"
            
            // dialogues 배열 생성 - 튜플 배열 구조로 생성
            var dialogues: [(speaker: String, text: String)] = []
            if let his = poll.his {
                dialogues.append(("나", his))
            }
            if let hers = poll.hers {
                dialogues.append(("상대방", hers))
            }
            
            // 옵션 파싱
            var options: [String] = []
            if let optionData = poll.option as? Data {
                do {
                    if let parsedOptions = try JSONSerialization.jsonObject(with: optionData) as? [String] {
                        options = parsedOptions
                    }
                } catch {
                    print("옵션 데이터 파싱 실패: \(error)")
                    options = ["옵션 A", "옵션 B", "옵션 C", "옵션 D"]
                }
            } else {
                options = ["옵션 A", "옵션 B", "옵션 C", "옵션 D"]
            }
            
            // PollContent 생성
            let content = PollContent(
                title: title,
                body: body,
                dialogues: dialogues,
                question: "어떤 생각이 더 맞는 것 같나요?",
                options: options
            )
            
            pollContents.append(content)
        }
        
        // 3개의 PollContent가 필요하므로, 부족한 경우 기본 템플릿으로 채우기
        while pollContents.count < 3 {
            pollContents.append(PollContent.defaultTemplate())
        }
    }
}
