//
//  ChatGPTResponse.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//

import Foundation

struct ChatGPTResponse: Decodable {
    // MARK: - Nested Types

    struct Choice: Decodable {
        // MARK: - Nested Types

        enum CodingKeys: String, CodingKey {
            case index
            case message
            case finishReason = "finish_reason"
        }

        // MARK: - Properties

        let index: Int
        let message: Message
        let finishReason: String?
    }

    struct Message: Decodable {
        let role: String
        let content: String
    }

    // MARK: - Properties

    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
}

extension ChatGPTResponse {
    // String으로 반환되는 ChatGPT response를 커스텀 모델로 파싱
    func convertToAnalysisData(_ response: ChatGPTResponse) throws -> AnalysisData {
        guard let content = response.choices.first?.message.content else {
            throw NSError(domain: String(describing: ChatGPTManager.self), code: 1, userInfo:
            [NSLocalizedDescriptionKey: "ChatGPT 응답 내용이 없습니다"])
        }
        
        var analysisData = AnalysisData()
        
        // 1. title 추출
        if let titleMatch = content.range(of: "제목: ([^\n]+)", options: .regularExpression) {
            let titleRange = titleMatch.lowerBound ..< titleMatch.upperBound
            let titleString = String(content[titleRange])
            analysisData.title = titleString.replacingOccurrences(of: "제목: ", with: "")
        }
        
        // 2. contents 추출
        let issuePattern = "쟁점 (\\d+): ([^\n]+)"
        let issueRegex = try NSRegularExpression(pattern: issuePattern)
        let nsString = content as NSString
        let issueMatch = issueRegex.matches(in: content, options: [], range: NSRange(location: 0, length: nsString.length))
        
        var issues = [String]()
        issueMatch.forEach { match in
            if match.numberOfRanges > 2 {
                let issueNumber = nsString.substring(with: match.range(at: 1))
                let issueText = nsString.substring(with: match.range(at: 2))
                issues.append("\(issueNumber). \(issueText)")
            }
        }
        
        analysisData.contents = issues.joined(separator: "\n")
        
        // 3. level 추출
        
        // 4. poll 추출
        let pollPatern = "쟁점 제목: ([^\n]+)\\s*내용: ([^\n]+)\\s*나의 의견: ([^\n]+)\\s*상대방 의견: ([^\n]+)\\s*옵션: ([^\n]+)"
        let pollRegex = try NSRegularExpression(pattern: pollPatern, options: [])
        let pollMatchs = pollRegex.matches(in: content, options: [], range: NSRange(location: 0, length: nsString.length))
        
        pollMatchs.forEach { match in
            if match.numberOfRanges > 5 {
                var pollData = PollData()
                pollData.title = nsString.substring(with: match.range(at: 1))
                pollData.contents = nsString.substring(with: match.range(at: 2))
                pollData.his = nsString.substring(with: match.range(at: 3))
                pollData.hers = nsString.substring(with: match.range(at: 4))
                
                let optionString = nsString.substring(with: match.range(at: 5))
                let rawOptions = optionString.components(separatedBy: ", ")
                let optionLabels = ["A", "B", "C", "D"]
                
                for i in 0 ..< 4 {
                    pollData.options.append("\(optionLabels[i]). \(rawOptions[i])")
                }
                
                analysisData.polls!.append(pollData)
            }
        }
        
        // 5. Summary 추출
        if let summaryStartRange = content.range(of: "커뮤니티", options: .caseInsensitive),
           let summaryTitleMatch = content.range(of: "제목: ([^\n]+)", options: .regularExpression, range: summaryStartRange.upperBound ..< content.endIndex) {
            let summaryTitleRange = summaryTitleMatch.lowerBound ..< summaryTitleMatch.upperBound
            let summaryTitleString = String(content[summaryTitleRange])
            analysisData.summary!.title = summaryTitleString.replacingOccurrences(of: "제목: ", with: "")
        }
        
        if let summaryStartRange = content.range(of: "커뮤니티", options: .caseInsensitive),
           let summaryContentMatch = content.range(of: "내용: ([\\s\\S]+)", options: .regularExpression, range: summaryStartRange.upperBound ..< content.endIndex) {
            let summaryContentRange = summaryContentMatch.lowerBound ..< summaryContentMatch.upperBound
            let summaryContentString = String(content[summaryContentRange])
            analysisData.summary!.contents = summaryContentString.replacingOccurrences(of: "내용: ", with: "")
        }
        
        analysisData.summary!.date = Date()
        
        print("아날리시스 데이터")
        print(analysisData)
        print()
        
        // 최종 데이터 리턴
        return analysisData
    }
}
