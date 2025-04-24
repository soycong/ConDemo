//
//  SpeakerSelectionViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/24/25.
//

import Foundation

final class SpeakerSelectionViewModel {
    private(set) var analysisData: AnalysisData
    
    init(analysisData: AnalysisData) {
        self.analysisData = analysisData
    }
    
    func getMessages() -> [MessageData] {
        return analysisData.messages ?? []
    }
    
    func isCurrentUser(_ userType: Bool) -> Bool {
        guard let messages = analysisData.messages, !messages.isEmpty else {
            return false
        }
        
        return messages[0].isFromCurrentUser == userType
    }
    
    // 화자 바뀜
    func switchSpeakers() {
        // 1. message 바꾸기
        guard let messagesData = analysisData.messages else { return }
        
        analysisData.messages = messagesData.map { message in
            var updatedMessage = message
            updatedMessage.switchUser()
            return updatedMessage
        }
        
        // 2. poll 입장 바꾸기
        guard let pollData = analysisData.polls else { return }
        
        analysisData.polls = pollData.map { poll in
            var updatedPoll = poll
            updatedPoll.switchOpinions()
            return updatedPoll
        }
        
        // 3. summary 바꾸기
        modifySummaryData(needModify: true)
    }
    
    // 써머리 데이터 수정
    func modifySummaryData(needModify: Bool) {
        guard var summaries = analysisData.summaries else { return }
        
        summaries.removeAll {
            $0.isCurrentUser == needModify
        }
        
        analysisData.summaries = summaries
    }
}
