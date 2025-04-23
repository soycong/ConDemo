//
//  AnalysisData.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//

import Foundation

struct AnalysisData {
    
    // MARK: - Properties
    
    var title: String
    var date: Date
    var contents: String
    var level: Int
    var messages: [MessageData]?
    var log: LogData?
    var polls: [PollData]?
    var summaries: [SummaryData]?
    var detailedTranscriptAnalysisData: DetailedTranscriptAnalysisData? // 대화 상세 분석
    
    init() {
        self.title = ""
        self.date = Date()
        self.contents = ""
        self.level = 0
        self.messages = nil
        self.log = nil
        self.polls = nil
        self.summaries = nil
        self.detailedTranscriptAnalysisData = nil
    }
}


struct LogData {
    let date: Date
    let contents: String
}

struct PollData {
    var date: Date
    var title: String
    var contents: String
    var myOpinion: String
    var yourOpinion: String
    var options: [String]
    
    init() {
        self.date = Date()
        self.title = ""
        self.contents = ""
        self.myOpinion = ""
        self.yourOpinion = ""
        self.options = []
    }
    
    mutating func switchOpinions() {
        let tempOpinion = self.yourOpinion
        self.yourOpinion = self.myOpinion
        self.myOpinion = tempOpinion
    }
}

struct SummaryData {
    var title: String
    var contents: String
    var date: Date
    var isCurrentUser: Bool
    
    init(title: String = "", contents: String = "", date: Date = Date(), isCurrentUser: Bool) {
        self.title = title
        self.contents = contents
        self.date = date
        self.isCurrentUser = isCurrentUser
    }
}

// MARK: - 대화 상세 분석 모델
struct DetailedTranscriptAnalysisData: Codable {
    var speakingTime: SpeakingTimeData
    var overlaps: OverlapsData
    var overlapTopics: [String]
    var consistency: ConsistencyData
    var factualAccuracy: FactualAccuracyData
    var sentimentAnalysis: SentimentAnalysisData
    var incorrectUsage: IncorrectUsageData
    var date: Date?
    
    init() {
        self.speakingTime = SpeakingTimeData()
        self.overlaps = OverlapsData()
        self.overlapTopics = []
        self.consistency = ConsistencyData()
        self.factualAccuracy = FactualAccuracyData()
        self.sentimentAnalysis = SentimentAnalysisData()
        self.incorrectUsage = IncorrectUsageData()
        self.date = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case speakingTime, overlaps, overlapTopics, consistency, factualAccuracy, sentimentAnalysis, incorrectUsage, date
    }
}

struct SpeakingTimeData: Codable {
    var speakerA: Double = 0.0
    var speakerB: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case speakerA, speakerB
    }
}

struct OverlapsData: Codable {
    var count: Int = 0
    var totalDuration: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case count, totalDuration
    }
}

struct SpeakerEvaluationData: Codable {
    var score: Int = 0
    var reasoning: String = ""
}

struct ConsistencyData: Codable {
    var speakerA: SpeakerEvaluationData = SpeakerEvaluationData()
    var speakerB: SpeakerEvaluationData = SpeakerEvaluationData()
    
    enum CodingKeys: String, CodingKey {
        case speakerA, speakerB
    }
}

struct FactualAccuracyData: Codable {
    var speakerA: SpeakerEvaluationData = SpeakerEvaluationData()
    var speakerB: SpeakerEvaluationData = SpeakerEvaluationData()
    
    enum CodingKeys: String, CodingKey {
        case speakerA, speakerB
    }
}

struct SentimentExamplesData: Codable {
    var positiveRatio: Double = 0.0
    var negativeRatio: Double = 0.0
    var positiveExamples: [String] = []
    var negativeExamples: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case positiveRatio, negativeRatio, positiveExamples, negativeExamples
    }
}

struct SentimentAnalysisData: Codable {
    var speakerA: SentimentExamplesData = SentimentExamplesData()
    var speakerB: SentimentExamplesData = SentimentExamplesData()
    
    enum CodingKeys: String, CodingKey {
        case speakerA, speakerB
    }
}

struct IncorrectUsageExamplesData: Codable {
    var count: Int = 0
    var examples: [String] = []
}

struct IncorrectUsageData: Codable {
    var speakerA: IncorrectUsageExamplesData = IncorrectUsageExamplesData()
    var speakerB: IncorrectUsageExamplesData = IncorrectUsageExamplesData()
    
    enum CodingKeys: String, CodingKey {
        case speakerA, speakerB
    }
}

extension SpeakingTimeData {
    static let dummies = [
        SpeakingTimeData(speakerA: 120.5, speakerB: 85.3),
        SpeakingTimeData(speakerA: 45.8, speakerB: 130.2),
        SpeakingTimeData(speakerA: 75.0, speakerB: 78.5),
        SpeakingTimeData(speakerA: 200.3, speakerB: 150.7),
        SpeakingTimeData(speakerA: 60.5, speakerB: 62.8),
        SpeakingTimeData(speakerA: 88.4, speakerB: 95.1),
        SpeakingTimeData(speakerA: 105.7, speakerB: 110.3),
        SpeakingTimeData(speakerA: 150.2, speakerB: 35.6),
        SpeakingTimeData(speakerA: 65.9, speakerB: 160.4),
        SpeakingTimeData(speakerA: 92.1, speakerB: 88.9)
    ]
}

extension SentimentAnalysisData {
    static let dummies = [
        SentimentAnalysisData(
            speakerA: SentimentExamplesData(
                positiveRatio: 0.65,
                negativeRatio: 0.60,
                positiveExamples: ["정말 좋은 아이디어네요", "이 제안은 매우 흥미롭습니다", "당신의 의견에 동의합니다"],
                negativeExamples: ["그건 좀 문제가 있을 것 같아요", "확신이 들지 않네요"]
            ),
            speakerB: SentimentExamplesData(
                positiveRatio: 0.35,
                negativeRatio: 0.40,
                positiveExamples: ["좋은 관점이네요", "그것 참 유용한 제안이군요"],
                negativeExamples: ["그렇게 하면 안 될 것 같아요", "이 방법은 비효율적입니다", "그건 우리 목표와 맞지 않습니다"]
            )
        ),
        SentimentAnalysisData(
            speakerA: SentimentExamplesData(
                positiveRatio: 0.30,
                negativeRatio: 0.45,
                positiveExamples: ["좋은 의견입니다", "그 부분은 잘 생각하셨네요"],
                negativeExamples: ["이건 실현 가능성이 낮아 보입니다", "이 접근법은 위험할 수 있습니다", "지금은 좋은 시기가 아닙니다", "예산 문제가 있을 것 같습니다"]
            ),
            speakerB: SentimentExamplesData(
                positiveRatio: 0.70,
                negativeRatio: 0.55,
                positiveExamples: ["훌륭한 분석이에요", "정말 창의적인 해결책이네요", "이 방향으로 진행하면 좋을 것 같아요", "당신의 노력이 정말 인상적입니다"],
                negativeExamples: ["일정이 너무 타이트해요", "비용이 좀 걱정됩니다"]
            )
        ),
        SentimentAnalysisData(
            speakerA: SentimentExamplesData(
                positiveRatio: 0.45,
                negativeRatio: 0.55,
                positiveExamples: ["이것은 우리에게 큰 기회입니다", "팀원들이 이 아이디어를 좋아할 거예요", "이 전략은 효과적일 것 같습니다"],
                negativeExamples: ["시간이 충분하지 않을 수 있어요", "몇 가지 리스크가 있습니다", "이전에 비슷한 시도가 실패했었죠"]
            ),
            speakerB: SentimentExamplesData(
                positiveRatio: 0.55,
                negativeRatio: 0.45,
                positiveExamples: ["당신의 접근 방식이 마음에 듭니다", "이 계획은 매우 체계적이네요", "잘 정리된 제안입니다"],
                negativeExamples: ["몇 가지 세부 사항이 누락된 것 같아요", "더 많은 데이터가 필요할 것 같습니다"]
            )
        ),
        SentimentAnalysisData(
            speakerA: SentimentExamplesData(
                positiveRatio: 0.40,
                negativeRatio: 0.35,
                positiveExamples: ["일부 아이디어는 가능성이 있어 보입니다", "몇 가지 좋은 제안이 있네요"],
                negativeExamples: ["이 전략은 우리 상황에 맞지 않습니다", "이건 너무 비현실적입니다", "이런 방식은 효과가 없을 거예요"]
            ),
            speakerB: SentimentExamplesData(
                positiveRatio: 0.60,
                negativeRatio: 0.65,
                positiveExamples: ["몇 가지 좋은 요소가 있네요", "그 부분은 동의합니다", "이 관점은 고려해볼 만합니다"],
                negativeExamples: ["이 계획은 현실적이지 않습니다", "우리 리소스로는 불가능해요", "타임라인이 너무 낙관적입니다", "고객들이 이것을 좋아하지 않을 것 같습니다"]
            )
        ),
        SentimentAnalysisData(
            speakerA: SentimentExamplesData(
                positiveRatio: 0.55,
                negativeRatio: 0.40,
                positiveExamples: ["이 제안은 혁신적입니다", "정말 뛰어난 아이디어예요", "이 방향이 우리의 목표와 완벽하게 일치합니다", "이것은 게임 체인저가 될 수 있습니다"],
                negativeExamples: ["구현이 조금 복잡할 수 있어요", "시간이 좀 걸릴 수도 있습니다"]
            ),
            speakerB: SentimentExamplesData(
                positiveRatio: 0.45,
                negativeRatio: 0.60,
                positiveExamples: ["정말 창의적인 제안이네요", "당신의 열정이 인상적입니다", "이 아이디어는 큰 잠재력이 있어요"],
                negativeExamples: ["일부 이해관계자들이 반대할 수도 있습니다", "추가 자원이 필요할 것 같아요", "일정 조정이 필요할 수 있습니다", "비용이 예상보다 높을 수 있습니다"]
            )
        )
    ]
}
