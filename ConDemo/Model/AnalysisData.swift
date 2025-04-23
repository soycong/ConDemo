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

//// SummaryData의 Codable 구현 업데이트
//extension SummaryData: Codable {
//    enum CodingKeys: String, CodingKey {
//        case title, contents, content, date, description, isCurrentUser
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        // title 디코딩 - 없으면 빈 문자열 사용
//        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
//
//        // contents 디코딩 - 여러 가능한 키 이름 시도
//        if let contents = try container.decodeIfPresent(String.self, forKey: .contents) {
//            self.contents = contents
//        } else if let content = try container.decodeIfPresent(String.self, forKey: .content) {
//            self.contents = content
//        } else if let description = try container.decodeIfPresent(String.self, forKey: .description) {
//            self.contents = description
//        } else {
//            self.contents = "" // 기본값
//        }
//
//        // isCurrentUser 디코딩 - 기본값은 true
//        isCurrentUser = try container.decodeIfPresent(Bool.self, forKey: .isCurrentUser) ?? true
//
//        // 날짜는 항상 현재로 설정
//        self.date = Date()
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(title, forKey: .title)
//        try container.encode(contents, forKey: .contents)
//        try container.encode(isCurrentUser, forKey: .isCurrentUser)
//    }
//}
//
//// PollData의 Codable 구현 업데이트
//extension PollData: Codable {
//    enum CodingKeys: String, CodingKey {
//        case date, title, contents, content, description, yourOpinion, myOpinion, options, his, hers
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        // title 디코딩
//        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
//
//        // contents 디코딩 - 여러 가능한 키 이름 시도
//        if let contents = try container.decodeIfPresent(String.self, forKey: .contents) {
//            self.contents = contents
//        } else if let content = try container.decodeIfPresent(String.self, forKey: .content) {
//            self.contents = content
//        } else if let description = try container.decodeIfPresent(String.self, forKey: .description) {
//            self.contents = description
//        } else {
//            self.contents = "" // 기본값
//        }
//
//        // my/your Opinions 디코딩 (backward compatibility 지원)
//        if let myOpinion = try container.decodeIfPresent(String.self, forKey: .myOpinion) {
//            self.myOpinion = myOpinion
//        } else if let his = try container.decodeIfPresent(String.self, forKey: .his) {
//            self.myOpinion = his
//        } else {
//            self.myOpinion = ""
//        }
//
//        if let yourOpinion = try container.decodeIfPresent(String.self, forKey: .yourOpinion) {
//            self.yourOpinion = yourOpinion
//        } else if let hers = try container.decodeIfPresent(String.self, forKey: .hers) {
//            self.yourOpinion = hers
//        } else {
//            self.yourOpinion = ""
//        }
//
//        // options 디코딩
//        options = try container.decodeIfPresent([String].self, forKey: .options) ?? []
//
//        // 날짜는 항상 현재로 설정
//        date = Date()
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(title, forKey: .title)
//        try container.encode(contents, forKey: .contents)
//        try container.encode(myOpinion, forKey: .myOpinion)
//        try container.encode(yourOpinion, forKey: .yourOpinion)
//        try container.encode(options, forKey: .options)
//    }
//}
//
//// AnalysisData의 Codable 구현 업데이트
//extension AnalysisData: Codable {
//    enum CodingKeys: String, CodingKey {
//        case title, date, contents, content, description, level, polls, summaries, summary
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        // title 디코딩
//        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
//
//        // contents 디코딩 - 여러 가능한 키 이름과 타입 시도
//        if let contents = try container.decodeIfPresent(String.self, forKey: .contents) {
//            self.contents = contents
//        } else if let content = try container.decodeIfPresent(String.self, forKey: .content) {
//            self.contents = content
//        } else if let description = try container.decodeIfPresent(String.self, forKey: .description) {
//            self.contents = description
//        } else if let contentsArray = try? container.decode([String].self, forKey: .contents) {
//            // 배열인 경우 문자열로 변환
//            self.contents = contentsArray.joined(separator: "\n")
//        } else if let contentsArray = try? container.decode([String].self, forKey: .content) {
//            // content 키로 배열인 경우도 처리
//            self.contents = contentsArray.joined(separator: "\n")
//        } else {
//            self.contents = "" // 기본값
//        }
//
//        // level 디코딩
//        level = try container.decodeIfPresent(Int.self, forKey: .level) ?? 1
//
//        // polls 필드 디코딩 - 다양한 경우 처리
//        do {
//            // 1. 배열로 먼저 시도
//            polls = try container.decodeIfPresent([PollData].self, forKey: .polls)
//        } catch {
//            print("배열로 디코딩 실패, 다른 방법 시도: \(error)")
//
//            // 2. 빈 배열 생성 후 polls가 딕셔너리인 경우 처리
//            polls = []
//
//            // 3. polls가 딕셔너리인 경우 처리
//            if let pollsDict = try? container.decodeIfPresent([String: PollData].self, forKey: .polls) {
//                polls = Array(pollsDict.values)
//            }
//
//            // 4. polls가 단일 객체인 경우 처리
//            if let singlePoll = try? container.decodeIfPresent(PollData.self, forKey: .polls) {
//                polls?.append(singlePoll)
//            }
//        }
//
//        // summaries 필드 디코딩 (새로운 구조)
//        do {
//            // 1. summaries 배열로 먼저 시도
//            if let decodedSummaries = try? container.decodeIfPresent([SummaryData].self, forKey: .summaries) {
//                summaries = decodedSummaries
//            }
//            // 2. 단일 summary 객체로 시도 (이전 구조 지원)
//            else if let singleSummary = try? container.decodeIfPresent(SummaryData.self, forKey: .summary) {
//                // 단일 summary를 배열로 변환 (이전 버전 호환성)
//                let currentUserSummary = singleSummary
//
//                // 반대 관점의 summary 생성
//                var otherSummary = SummaryData(
//                    title: "상대방 관점의 " + currentUserSummary.title,
//                    contents: currentUserSummary.contents,
//                    date: Date(),
//                    isCurrentUser: false
//                )
//
//                // 내용을 반대 관점으로 변경 시도
//                if otherSummary.contents.contains("나는") {
//                    otherSummary.contents = otherSummary.contents
//                        .replacingOccurrences(of: "나는", with: "상대방은")
//                        .replacingOccurrences(of: "내가", with: "상대방이")
//                        .replacingOccurrences(of: "내", with: "상대방의")
//                }
//
//                summaries = [
//                    currentUserSummary,
//                    otherSummary
//                ]
//            } else {
//                // 3. 둘 다 없는 경우 기본값 생성
//                summaries = []
//            }
//        } catch {
//            print("summaries 디코딩 실패, 기본값 사용: \(error)")
//            summaries = []
//        }
//
//        // 기본값 설정
//        date = Date()
//        messages = nil
//        log = nil
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(title, forKey: .title)
//        try container.encode(contents, forKey: .contents)
//        try container.encode(level, forKey: .level)
//        try container.encodeIfPresent(polls, forKey: .polls)
//        try container.encodeIfPresent(summaries, forKey: .summaries)
//    }
//}

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
