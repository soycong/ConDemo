//
//  AnalysisData.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//

import Foundation

struct AnalysisData {
    // MARK: - Nested Types

    struct LogData {
        let date: Date
        let contents: String
    }

    struct PollData {
        let date: Date
        let title: String
        let contents: String
        let hers: String
        let his: String
        let options: [String]
    }

    struct SummaryData {
        let title: String
        let contents: String
        let date: Date
    }

    // MARK: - Properties

    let title: String
    let date: Date
    let contents: String
    let level: Int
    let messages: [MessageData]
    let log: LogData
    let polls: [PollData]
    let summary: SummaryData
}
