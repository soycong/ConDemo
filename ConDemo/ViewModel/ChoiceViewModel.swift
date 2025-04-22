//
//  ChoiceViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/21/25.
//

final class ChoiceViewModel {
    private(set) var analysisData: AnalysisData
    
    init(analysisData: AnalysisData) {
        self.analysisData = analysisData
    }
}

// 전체 스크립트를 띄워주고, 여자면 빨간색으로 남자면 파란색으로 체크해서 둘 중에 하나를 선택하도록.
extension ChoiceViewModel {
    func extractData() -> [String] {
        guard let messages = analysisData.messages,
              messages.count >= 1 else {
            let mine = "오류 났습니다"
            let yours = "이런..."
            return [mine, yours]
        }
        let mine = messages[0].text
        let yours = messages[1].text
        return [mine, yours]
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
        
        CoreDataManager.shared.saveAnalysis(data: analysisData)
    }
}
