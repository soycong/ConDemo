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
    var consistency: ConsistencyData
    var factualAccuracy: FactualAccuracyData
    var sentimentAnalysis: SentimentAnalysisData
    var date: Date?
    
    init() {
        self.speakingTime = SpeakingTimeData()
        self.consistency = ConsistencyData()
        self.factualAccuracy = FactualAccuracyData()
        self.sentimentAnalysis = SentimentAnalysisData()
        self.date = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case speakingTime, consistency, factualAccuracy, sentimentAnalysis, date
    }
}

struct SpeakingTimeData: Codable {
    var speakerA: Double = 0.0
    var speakerB: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case speakerA, speakerB
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

// SummaryData의 Codable 구현 업데이트
extension SummaryData: Codable {
    enum CodingKeys: String, CodingKey {
        case title, contents, content, date, description, isCurrentUser
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // title 디코딩 - 없으면 빈 문자열 사용
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        
        // contents 디코딩 - 여러 가능한 키 이름 시도
        if let contents = try container.decodeIfPresent(String.self, forKey: .contents) {
            self.contents = contents
        } else if let content = try container.decodeIfPresent(String.self, forKey: .content) {
            self.contents = content
        } else if let description = try container.decodeIfPresent(String.self, forKey: .description) {
            self.contents = description
        } else {
            self.contents = "" // 기본값
        }
        
        // isCurrentUser 디코딩 - 기본값은 true
        isCurrentUser = try container.decodeIfPresent(Bool.self, forKey: .isCurrentUser) ?? true
        
        // 날짜는 항상 현재로 설정
        self.date = Date()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(contents, forKey: .contents)
        try container.encode(isCurrentUser, forKey: .isCurrentUser)
    }
}

// PollData의 Codable 구현 업데이트
extension PollData: Codable {
    enum CodingKeys: String, CodingKey {
        case date, title, contents, content, description, yourOpinion, myOpinion, options, his, hers
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // title 디코딩
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        
        // contents 디코딩 - 여러 가능한 키 이름 시도
        if let contents = try container.decodeIfPresent(String.self, forKey: .contents) {
            self.contents = contents
        } else if let content = try container.decodeIfPresent(String.self, forKey: .content) {
            self.contents = content
        } else if let description = try container.decodeIfPresent(String.self, forKey: .description) {
            self.contents = description
        } else {
            self.contents = "" // 기본값
        }
        
        // my/your Opinions 디코딩 (backward compatibility 지원)
        if let myOpinion = try container.decodeIfPresent(String.self, forKey: .myOpinion) {
            self.myOpinion = myOpinion
        } else if let his = try container.decodeIfPresent(String.self, forKey: .his) {
            self.myOpinion = his
        } else {
            self.myOpinion = ""
        }
        
        if let yourOpinion = try container.decodeIfPresent(String.self, forKey: .yourOpinion) {
            self.yourOpinion = yourOpinion
        } else if let hers = try container.decodeIfPresent(String.self, forKey: .hers) {
            self.yourOpinion = hers
        } else {
            self.yourOpinion = ""
        }
        
        // options 디코딩
        options = try container.decodeIfPresent([String].self, forKey: .options) ?? []
        
        // 날짜는 항상 현재로 설정
        date = Date()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(contents, forKey: .contents)
        try container.encode(myOpinion, forKey: .myOpinion)
        try container.encode(yourOpinion, forKey: .yourOpinion)
        try container.encode(options, forKey: .options)
    }
}

// AnalysisData의 Codable 구현 업데이트
extension AnalysisData: Codable {
    enum CodingKeys: String, CodingKey {
        case title, date, contents, content, description, level, polls, summaries, summary, detailedTranscriptAnalysisData
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // title 디코딩
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        
        // contents 디코딩 - 여러 가능한 키 이름과 타입 시도
        if let contents = try container.decodeIfPresent(String.self, forKey: .contents) {
            self.contents = contents
        } else if let content = try container.decodeIfPresent(String.self, forKey: .content) {
            self.contents = content
        } else if let description = try container.decodeIfPresent(String.self, forKey: .description) {
            self.contents = description
        } else if let contentsArray = try? container.decode([String].self, forKey: .contents) {
            // 배열인 경우 문자열로 변환
            self.contents = contentsArray.joined(separator: "\n")
        } else if let contentsArray = try? container.decode([String].self, forKey: .content) {
            // content 키로 배열인 경우도 처리
            self.contents = contentsArray.joined(separator: "\n")
        } else {
            self.contents = "" // 기본값
        }
        
        // level 디코딩
        level = try container.decodeIfPresent(Int.self, forKey: .level) ?? 1
        
        // polls 필드 디코딩 - 다양한 경우 처리
        do {
            // 1. 배열로 먼저 시도
            polls = try container.decodeIfPresent([PollData].self, forKey: .polls)
        } catch {
            print("배열로 디코딩 실패, 다른 방법 시도: \(error)")
            
            // 2. 빈 배열 생성 후 polls가 딕셔너리인 경우 처리
            polls = []
            
            // 3. polls가 딕셔너리인 경우 처리
            if let pollsDict = try? container.decodeIfPresent([String: PollData].self, forKey: .polls) {
                polls = Array(pollsDict.values)
            }
            
            // 4. polls가 단일 객체인 경우 처리
            if let singlePoll = try? container.decodeIfPresent(PollData.self, forKey: .polls) {
                polls?.append(singlePoll)
            }
        }
        
        // summaries 필드 디코딩 (새로운 구조)
        do {
            // 1. summaries 배열로 먼저 시도
            if let decodedSummaries = try? container.decodeIfPresent([SummaryData].self, forKey: .summaries) {
                summaries = decodedSummaries
            }
            // 2. 단일 summary 객체로 시도 (이전 구조 지원)
            else if let singleSummary = try? container.decodeIfPresent(SummaryData.self, forKey: .summary) {
                // 단일 summary를 배열로 변환 (이전 버전 호환성)
                let currentUserSummary = singleSummary
                
                // 반대 관점의 summary 생성
                var otherSummary = SummaryData(
                    title: "상대방 관점의 " + currentUserSummary.title,
                    contents: currentUserSummary.contents,
                    date: Date(),
                    isCurrentUser: false
                )
                
                // 내용을 반대 관점으로 변경 시도
                if otherSummary.contents.contains("나는") {
                    otherSummary.contents = otherSummary.contents
                        .replacingOccurrences(of: "나는", with: "상대방은")
                        .replacingOccurrences(of: "내가", with: "상대방이")
                        .replacingOccurrences(of: "내", with: "상대방의")
                }
                
                summaries = [
                    currentUserSummary,
                    otherSummary
                ]
            } else {
                // 3. 둘 다 없는 경우 기본값 생성
                summaries = []
            }
        } catch {
            print("summaries 디코딩 실패, 기본값 사용: \(error)")
            summaries = []
        }
        
        // DetailedTranscriptAnalysisData 디코딩
        detailedTranscriptAnalysisData = try container.decodeIfPresent(DetailedTranscriptAnalysisData.self, forKey: .detailedTranscriptAnalysisData)
        
        // 기본값 설정
        date = Date()
        messages = nil
        log = nil
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(contents, forKey: .contents)
        try container.encode(level, forKey: .level)
        try container.encodeIfPresent(polls, forKey: .polls)
        try container.encodeIfPresent(summaries, forKey: .summaries)
        try container.encodeIfPresent(detailedTranscriptAnalysisData, forKey: .detailedTranscriptAnalysisData)
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

extension ConsistencyData {
    static let dummies = [
        ConsistencyData(
            speakerA: SpeakerEvaluationData(score: 2, reasoning: "주장이 자주 바뀌고 일관성이 부족함"),
            speakerB: SpeakerEvaluationData(score: 5, reasoning: "처음부터 끝까지 논리적으로 일관된 주장을 펼침")
        ),
        ConsistencyData(
            speakerA: SpeakerEvaluationData(score: 4, reasoning: "대체로 일관된 주장을 펼쳤으나 일부 모순된 부분이 있음"),
            speakerB: SpeakerEvaluationData(score: 3, reasoning: "주요 논점에서 자주 입장을 바꿈")
        ),
        ConsistencyData(
            speakerA: SpeakerEvaluationData(score: 5, reasoning: "명확하고 일관된 주장으로 논리적 흐름을 유지함"),
            speakerB: SpeakerEvaluationData(score: 1, reasoning: "대화 내내 주장이 계속 변하고 모순됨")
        ),
        ConsistencyData(
            speakerA: SpeakerEvaluationData(score: 1, reasoning: "자신의 이전 발언과 계속 충돌하는 주장을 함"),
            speakerB: SpeakerEvaluationData(score: 4, reasoning: "주로 일관된 논리를 보여주나 가끔 입장을 바꿈")
        ),
        ConsistencyData(
            speakerA: SpeakerEvaluationData(score: 3, reasoning: "일부 주제에서는 일관되지만 다른 부분에서 모순됨"),
            speakerB: SpeakerEvaluationData(score: 2, reasoning: "핵심 주장에서 자주 모순되는 발언을 함")
        )
    ]
}

extension FactualAccuracyData {
    static let dummies = [
        FactualAccuracyData(
            speakerA: SpeakerEvaluationData(score: 2, reasoning: "몇 가지 부정확한 정보를 제시함"),
            speakerB: SpeakerEvaluationData(score: 1, reasoning: "대부분의 주장이 사실과 다름")
        ),
        FactualAccuracyData(
            speakerA: SpeakerEvaluationData(score: 4, reasoning: "대부분 정확한 정보를 제공하나 일부 오류가 있음"),
            speakerB: SpeakerEvaluationData(score: 3, reasoning: "일부 사실은 정확하나 중요한 부분에서 오류가 있음")
        ),
        FactualAccuracyData(
            speakerA: SpeakerEvaluationData(score: 1, reasoning: "정확한 정보가 거의 없고 대부분 사실 왜곡이 심함"),
            speakerB: SpeakerEvaluationData(score: 5, reasoning: "모든 주장이 검증 가능한 사실에 기반함")
        ),
        FactualAccuracyData(
            speakerA: SpeakerEvaluationData(score: 5, reasoning: "매우 정확한 데이터와 통계를 사용함"),
            speakerB: SpeakerEvaluationData(score: 2, reasoning: "여러 사실을 오해하거나 잘못 인용함")
        ),
        FactualAccuracyData(
            speakerA: SpeakerEvaluationData(score: 3, reasoning: "주요 사실은 맞지만 세부 정보에서 부정확함"),
            speakerB: SpeakerEvaluationData(score: 4, reasoning: "전반적으로 신뢰할 수 있는 정보를 제공함")
        )
    ]
}
