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
    var summary: SummaryData?
    
    init() {
        self.title = ""
        self.date = Date()
        self.contents = ""
        self.level = 0
        self.messages = nil
        self.log = nil
        self.polls = nil
        self.summary = nil
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
    var hers: String
    var his: String
    var options: [String]
    
    init() {
        self.date = Date()
        self.title = ""
        self.contents = ""
        self.hers = ""
        self.his = ""
        self.options = []
    }
}

struct SummaryData {
    var title: String
    var contents: String
    var date: Date
    
    init(title: String = "", contents: String = "", date: Date = Date()) {
        self.title = title
        self.contents = contents
        self.date = date
    }
}
