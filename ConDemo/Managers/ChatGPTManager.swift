//
//  ChatGPTManager.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//

import Alamofire
import CoreData
import Foundation
import UIKit

final class ChatGPTManager {
    // MARK: - Static Properties

    static let shared: ChatGPTManager = .init()

    // MARK: - Properties

    private let endpoint = "https://api.openai.com/v1/chat/completions"

    // MARK: - Lifecycle

    private init() { }

    // MARK: - Functions

    func analyzeTranscript(messages: [MessageData]) async throws -> AnalysisData {
        let transcript = messages.map {
            "\($0.isFromCurrentUser ? "나" : "상대방"): \($0.text)"
        }.joined(separator: "\n")

        let response = try await requestAnalysis(transcript: transcript)
        var analysisData = try convertToAnalysisData(response)
        
        // 분석 데이터에 메시지 포함
        analysisData.messages = messages
        
        return analysisData
    }

    private func requestAnalysis(transcript: String) async throws -> ChatGPTResponse {
        let text = """
                다음은 두 사람 간의 대화 내용입니다:

                \(transcript)

                이 대화를 분석하여 다음 정보를 제공해주세요:

                1. 대화를 요약하는 제목(10자 이하)과 주요 쟁점 3가지를 추출해주세요. 재밌고 매력적이게 추출해주세요.
        
                2. 싸움의 격한 정도를 1~9단계로 나타내주세요.

                3. 3개 쟁점 각각에 대한 poll을 생성해주세요. 각 poll은 다음 형식을 따라야 합니다:
                   - 쟁점 제목: [제목]
                   - 내용: [내용 설명]
                   - 나의 의견: [첫 번째 화자의 의견]
                   - 상대방 의견: [두 번째 화자의 의견]
                   - 옵션: [투표 옵션들, 쉼표로 구분, 총 4개]

                4. 커뮤니티에 게시글로 올라갈 요약본을 작성해주세요. 다음 형식을 따라야 합니다:
                   - 제목: [대화 주제를 반영한 간결하고 매력적인 제목]
                   - 내용: [대화의 핵심 내용과 결론을 포함한 300자 이내의 요약]

                각 섹션을 명확히 구분해서 응답해주고, 이모지를 포함해 재밌는 요소를 넣어주세요.
        """

        let parameters: [String: Any] = ["model": "gpt-4-1106-preview",
                                         "messages": [
                                             ["role": "system",
                                              "content": "당신은 대화 내용을 분석하고 요약하고, 요약 내용에 대한 poll 3개를 생성하는 도우미입니다. 한국어로 답변해주세요."],
                                             ["role": "user", "content": text],
                                         ],
                                         "temperature": 0.7]

        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": "Bearer \(APIKey.chatGPT)"]

        return try await withCheckedThrowingContinuation { continuation in
            // requestModifier를 사용하여 timeoutInterval 설정
            AF.request(endpoint,
                       method: .post,
                       parameters: parameters,
                       encoding: JSONEncoding.default,
                       headers: headers,
                       requestModifier: { $0.timeoutInterval = 300 }) // 타임아웃을 120초(2분)으로 늘림
                .validate()
                .responseDecodable(of: ChatGPTResponse.self) { response in
                    switch response.result {
                    case .success(let gptResponse):
                        continuation.resume(returning: gptResponse)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    private func convertToAnalysisData(_ response: ChatGPTResponse) throws -> AnalysisData {
        guard let content = response.choices.first?.message.content else {
            throw NSError(domain: String(describing: ChatGPTManager.self), code: 1, userInfo:
            [NSLocalizedDescriptionKey: "ChatGPT 응답 내용이 없습니다"])
        }
        
        var analysisData = AnalysisData()
        analysisData.date = Date()
        
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
        let levelPattern = "싸움의 격한 정도: (\\d+)"
        if let levelMatch = content.range(of: levelPattern, options: .regularExpression) {
            let levelString = String(content[levelMatch])
            if let levelDigit = levelString.components(separatedBy: ": ").last,
               let level = Int(levelDigit) {
                analysisData.level = level
            }
        }
        
        // 4. poll 추출
        analysisData.polls = []
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
                pollData.date = Date()
                
                let optionString = nsString.substring(with: match.range(at: 5))
                let rawOptions = optionString.components(separatedBy: ", ")
                let optionLabels = ["A", "B", "C", "D"]
                
                pollData.options = []
                for i in 0 ..< min(4, rawOptions.count) {
                    pollData.options.append("\(optionLabels[i]). \(rawOptions[i])")
                }
                
                analysisData.polls!.append(pollData)
            }
        }
        
        // 5. Summary 추출
        analysisData.summary = SummaryData()
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
        
        // 최종 데이터 리턴
        return analysisData
    }
}
