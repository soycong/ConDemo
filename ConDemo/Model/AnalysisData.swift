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
