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
    
    // 단순 채팅 기능 - 사용자 메시지에 대한 응답 얻기
    func getResponse(to userMessage: String, completion: @escaping (Result<String, Error>) -> Void) {
        let parameters: [String: Any] = [
            "model": "gpt-4-1106-preview",
            "messages": [
                ["role": "system", "content": "당신은 사용자의 질문에 도움을 주는 AI 어시스턴트입니다. 친절하고 자연스럽게 대화하세요. 한국어로 답변해주세요."],
                ["role": "user", "content": userMessage]
            ],
            "temperature": 0.7
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(APIKey.chatGPT)"
        ]
        
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: ChatGPTResponse.self) { response in
                switch response.result {
                case .success(let chatGPTResponse):
                    if let content = chatGPTResponse.choices.first?.message.content {
                        completion(.success(content))
                    } else {
                        completion(.failure(NSError(domain: "ChatGPTManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "응답 내용이 없습니다"])))
                    }
                case .failure(let error):
                    print("ChatGPT API 에러: \(error)")
                    // 응답 데이터가 있다면 출력
                    if let data = response.data {
                        let str = String(data: data, encoding: .utf8) ?? "데이터를 문자열로 변환할 수 없습니다"
                        print("응답 데이터: \(str)")
                    }
                    completion(.failure(error))
                }
            }
    }

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
                        print(gptResponse)
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
        
        // ChatGPT가 에러 메시지를 반환한 경우 처리
        if content.contains("대화 내용이 제공되지 않아") || content.contains("분석을 진행할 수 없습니다") {
            throw NSError(domain: String(describing: ChatGPTManager.self), code: 3, userInfo:
            [NSLocalizedDescriptionKey: "ChatGPT가 대화 내용을 분석할 수 없습니다: \(content)"])
        }
        
        // 기본값으로 초기화된 객체 생성
        var analysisData = AnalysisData()
        analysisData.date = Date()
        analysisData.title = "대화 분석"  // 기본 제목 설정
        analysisData.contents = ""       // 기본 내용 설정
        analysisData.level = 0           // 기본 레벨 설정
        analysisData.polls = []          // 빈 배열로 초기화
        
        // 1. title 추출 시도
        if let titleMatch = content.range(of: "제목: ([^\n]+)", options: .regularExpression) {
            let titleRange = titleMatch.lowerBound ..< titleMatch.upperBound
            let titleString = String(content[titleRange])
            analysisData.title = titleString.replacingOccurrences(of: "제목: ", with: "")
                .replacingOccurrences(of: "\"", with: "")
        }
        
        // 2. contents 추출 시도
        do {
            let issuePattern = "쟁점 (\\d+): ([^\n]+)"
            let issueRegex = try NSRegularExpression(pattern: issuePattern)
            let nsString = content as NSString
            let issueMatch = issueRegex.matches(in: content, options: [], range: NSRange(location: 0, length: nsString.length))
            
            var issues = [String]()
            issueMatch.forEach { match in
                if match.numberOfRanges > 2 {
                    let issueNumber = nsString.substring(with: match.range(at: 1))
                    let issueText = nsString.substring(with: match.range(at: 2))
                        .replacingOccurrences(of: "\"", with: "")
                    issues.append("\(issueNumber). \(issueText)")
                }
            }
            
            if !issues.isEmpty {
                analysisData.contents = issues.joined(separator: "\n")
            } else {
                // 이슈를 찾지 못한 경우, 직접 파싱 시도
                let lines = content.components(separatedBy: "\n")
                for line in lines where line.contains("쟁점") || line.contains("주요 내용") {
                    if issues.isEmpty {
                        issues.append(line.replacingOccurrences(of: "\"", with: ""))
                    }
                }
                
                if !issues.isEmpty {
                    analysisData.contents = issues.joined(separator: "\n")
                }
            }
        } catch {
            print("정규식 오류: \(error)")
        }
        
        // 3. level 추출 시도
        if let levelMatch = content.range(of: "싸움의 격한 정도: (\\d+)", options: .regularExpression) {
            let levelString = String(content[levelMatch])
            if let levelDigit = levelString.components(separatedBy: ": ").last,
               let level = Int(levelDigit) {
                analysisData.level = level
            }
        }
        
        // 4. poll 추출
        let pollPattern = "쟁점 제목:\\s*([^\\n]+)[\\s\\n]*-?\\s*내용:\\s*([^\\n]+)[\\s\\n]*-?\\s*나의 의견:\\s*([^\\n]+)[\\s\\n]*-?\\s*상대방 의견:\\s*([^\\n]+)[\\s\\n]*-?\\s*옵션:\\s*([^\\n]+)"
        
        do {
            let pollRegex = try NSRegularExpression(pattern: pollPattern, options: [.dotMatchesLineSeparators])
            let nsString = content as NSString
            let pollMatches = pollRegex.matches(in: content, options: [], range: NSRange(location: 0, length: nsString.length))
            
            print("찾은 Poll 수: \(pollMatches.count)")
            
            for match in pollMatches {
                if match.numberOfRanges > 5 {
                    var pollData = PollData()
                    pollData.title = nsString.substring(with: match.range(at: 1))
                        .replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    pollData.contents = nsString.substring(with: match.range(at: 2))
                        .replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    pollData.his = nsString.substring(with: match.range(at: 3))
                        .replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    pollData.hers = nsString.substring(with: match.range(at: 4))
                        .replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    pollData.date = Date()
                    
                    let optionString = nsString.substring(with: match.range(at: 5))
                    let rawOptions = optionString.components(separatedBy: ", ")
                    let optionLabels = ["A", "B", "C", "D"]
                    
                    pollData.options = []
                    for i in 0 ..< min(4, rawOptions.count) {
                        let option = rawOptions[i].replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                        pollData.options.append("\(optionLabels[i]). \(option)")
                    }
                    
                    analysisData.polls!.append(pollData)
                }
            }
            
            // 디버깅 - Poll 추출 결과 출력
            if analysisData.polls!.isEmpty {
                print("Poll을 추출하지 못했습니다. 원본 내용:")
                print(content)
            } else {
                print("Poll 추출 성공: \(analysisData.polls!.count)개")
            }
            
        } catch {
            print("Poll 정규식 오류: \(error)")
        }
        
        // Poll 추출 실패 시 fallback - 간단한 구분자로 2차 시도
        if analysisData.polls!.isEmpty {
            print("정규식을 통한 Poll 추출 실패. 내용 기반 추출 시도 중...")
            
            // 출력된 GPT 응답의 예제를 기준으로 파싱
            let polls = extractPollsFromContent(content)
            if !polls.isEmpty {
                analysisData.polls = polls
                print("내용 기반 Poll 추출 성공: \(polls.count)개")
            } else {
                print("내용 기반 Poll 추출 실패")
            }
        }
        
        // 5. Summary 추출 시도
        var summaryData = SummaryData()
        summaryData.date = Date()
        summaryData.title = "대화 요약"  // 기본 제목
        summaryData.contents = "대화 내용에 대한 요약입니다."  // 기본 내용
        
        // 커뮤니티 요약 제목 추출 시도
        if let summaryStartRange = content.range(of: "커뮤니티", options: .caseInsensitive),
           let summaryTitleMatch = content.range(of: "제목: ([^\n]+)", options: .regularExpression, range: summaryStartRange.upperBound ..< content.endIndex) {
            let summaryTitleRange = summaryTitleMatch.lowerBound ..< summaryTitleMatch.upperBound
            let summaryTitleString = String(content[summaryTitleRange])
            summaryData.title = summaryTitleString.replacingOccurrences(of: "제목: ", with: "")
                .replacingOccurrences(of: "\"", with: "")
        }
        
        // 커뮤니티 요약 내용 추출 시도
        if let summaryStartRange = content.range(of: "커뮤니티", options: .caseInsensitive),
           let summaryContentMatch = content.range(of: "내용: ([\\s\\S]+)", options: .regularExpression, range: summaryStartRange.upperBound ..< content.endIndex) {
            let summaryContentRange = summaryContentMatch.lowerBound ..< summaryContentMatch.upperBound
            let summaryContentString = String(content[summaryContentRange])
            summaryData.contents = summaryContentString.replacingOccurrences(of: "내용: ", with: "")
                .replacingOccurrences(of: "\"", with: "")
        }
        
        // 제목/내용 없이 분석이 필요한 경우 대화 내용으로 대체
        if summaryData.title == "대화 요약" && content.count > 30 {
            // API가 분석을 거부한 경우가 아니라면 응답의 일부를 요약으로 사용
            if !content.contains("대화 내용이 제공되지 않아") {
                summaryData.contents = String(content.prefix(300)).replacingOccurrences(of: "\"", with: "")
            }
        }
        
        analysisData.summary = summaryData
        
        return analysisData
    }
}

extension ChatGPTManager {
    private func extractPollsFromContent(_ content: String) -> [PollData] {
        var polls: [PollData] = []
        let lines = content.components(separatedBy: "\n")
        
        var currentPoll: PollData? = nil
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimmedLine.contains("쟁점 제목:") {
                // 이전 Poll 저장
                if let poll = currentPoll, !poll.title.isEmpty {
                    polls.append(poll)
                }
                
                // 새 Poll 시작
                currentPoll = PollData()
                currentPoll?.date = Date()
                currentPoll?.title = trimmedLine.replacingOccurrences(of: "쟁점 제목:", with: "")
                    .replacingOccurrences(of: "-", with: "")
                    .replacingOccurrences(of: "\"", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
            } else if var poll = currentPoll {
                // 기존 Poll에 정보 추가
                if trimmedLine.contains("내용:") {
                    poll.contents = trimmedLine.replacingOccurrences(of: "내용:", with: "")
                        .replacingOccurrences(of: "-", with: "")
                        .replacingOccurrences(of: "\"", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    
                } else if trimmedLine.contains("나의 의견:") {
                    poll.his = trimmedLine.replacingOccurrences(of: "나의 의견:", with: "")
                        .replacingOccurrences(of: "-", with: "")
                        .replacingOccurrences(of: "\"", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    
                } else if trimmedLine.contains("상대방 의견:") {
                    poll.hers = trimmedLine.replacingOccurrences(of: "상대방 의견:", with: "")
                        .replacingOccurrences(of: "-", with: "")
                        .replacingOccurrences(of: "\"", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    
                } else if trimmedLine.contains("옵션:") {
                    let optionsText = trimmedLine.replacingOccurrences(of: "옵션:", with: "")
                        .replacingOccurrences(of: "-", with: "")
                        .replacingOccurrences(of: "\"", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let rawOptions = optionsText.components(separatedBy: ", ")
                    let optionLabels = ["A", "B", "C", "D"]
                    
                    poll.options = []
                    for i in 0 ..< min(4, rawOptions.count) {
                        poll.options.append("\(optionLabels[i]). \(rawOptions[i].trimmingCharacters(in: .whitespaces))")
                    }
                }
            }
        }
        
        // 마지막 Poll 저장
        if let poll = currentPoll, !poll.title.isEmpty, !poll.options.isEmpty {
            polls.append(poll)
        }
        
        return polls
    }
}
