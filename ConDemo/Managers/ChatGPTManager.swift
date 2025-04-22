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
    private let defaultModel = "gpt-4-turbo"
    private let defaultSystemContent = "당신은 사용자의 질문에 도움을 주는 AI 어시스턴트. 친절하고 자연스럽게 대화 부탁. 한국어로 답변 부탁."
    private let defaultHeaders: HTTPHeaders = [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(APIKey.chatGPT)"
    ]
    
    // MARK: - Lifecycle
    
    private init() { }
    
    // MARK: - Functions
    
    private func createParameters(
        model: String = "gpt-4-turbo",
        systemContent: String? = nil,
        userContent: String,
        temperature: Double = 0.6
    ) -> [String: Any] {
        return [
            "model": model,
            "messages": [
                ["role": "system", "content": systemContent == nil ? defaultSystemContent : systemContent],
                ["role": "user", "content": userContent],
            ],
            "temperature": temperature
        ]
    }
    
    private func executeRequest(
        parameters: [String: Any],
        completion: @escaping (Result<String, Error>) -> Void
    ) -> Void {
        AF.request(
            endpoint,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: defaultHeaders
        )
        .validate()
        .responseDecodable(of: ChatGPTResponse.self) { response in
            switch response.result {
            case .success(let gptResponse):
                if let content = gptResponse.choices.first?.message.content {
                    completion(.success(content))
                } else {
                    completion(.failure(NSError(domain: String(describing: ChatGPTManager.self), code: 1, userInfo: [NSLocalizedDescriptionKey: "응답 내용이 없습니다"])))
                }
            case .failure(let error):
                print("ChatGPT API 에러: \(error)")
                
                if let data = response.data {
                    let str = String(data: data, encoding: .utf8) ?? "데이터를 문자열로 변환할 수 없습니다"
                    print("응답 데이터: \(str)")
                }
                completion(.failure(error))
            }
        }
    }
    
    // 단순 채팅 기능 - 사용자 메시지에 대한 응답 얻기
    func getResponse(to userMessage: String, completion: @escaping (Result<String, Error>) -> Void) {
        let parameters = createParameters(userContent: userMessage)
        executeRequest(parameters: parameters, completion: completion)
    }
    
    // 대화 내용을 포함한 응답 요청
    func getResponseWithTranscript(isInitial: Bool = false, userMessage: String, transcript: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        // 대화 내용을 포함한 메시지
        let fullPrompt = """
                    다음은 두 사람 간의 대화 내용입니다:
                    
                    \(transcript)
                    
                    위 대화 내용을 바탕으로 다음 질문에 답변해주세요:
                    """
        let userContent = "당신은 사용자의 질문에 도움을 주는 AI 어시스턴트입니다. \(fullPrompt) 친절하고 자연스럽게 대화하세요. 한국어로 답변해주세요. 답변은 300자 이하로 해주세요."
        let parameters = createParameters(userContent: userContent)

        executeRequest(parameters: parameters, completion: completion)
    }
    
    func analyzeTranscript(messages: [MessageData]) async throws -> AnalysisData {
        // 나,  상대방 지정
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
        다음 두 사람 간의 대화 내용을 아래 보내는 조건에 맞게 분석 부탁.
                \(transcript)
                1. 대화를 요약하는 제목(한글 10자 이하)과 주요 쟁점 3가지를 재밌고 매력적이게 추출.
                2. 싸움의 격한 정도를 1~10단계로 표현. 대화가 감지되지 않은 경우는 1단계로 표시.
                3. 3개 쟁점 각각에 대한 poll을 생성. 커뮤니티에 올라갈 투표. 제목을 재밌고 매력적이고 자극적이게 뽑아주고, 옵션도 재밌고 자극적이게 다른 사람들이 공감할 수 있는 내용의 구어체로 작성. 각 poll은 다음 형식을 따라야함:
                  - 쟁점 제목: [제목]
                  - 내용: [내용 설명]
                  - 나의 의견: [첫 번째 화자의 의견]
                  - 상대방 의견: [두 번째 화자의 의견]
                  - 옵션: [투표 옵션들, 쉼표로 구분, 총 4개]
                4. 커뮤니티에 게시글로 올라갈 요약본 작성 부탁. 제목은 자극적이고 재밌게 생성. 내용은 두 화자의 의견이 극명하게 갈리도록 생성, 두 화자의 말을 요약해서 나열하는 게 아니라, 각 화자의 입장에서 게시글 1개씩 총 2개 생성. 내 입장인 게시글을 먼저 반환해주고, 상대방 입장의 게시글을 뒤에 반환. 공감이 가고 흥미로운 스타일로 구성. 최대한 재밌고 매력있고 끌릴만하게 표현. 사람들이 실제로 커뮤니티에 올리는 글처럼 생성. 다음 형식을 따라야함:
                  - 제목: [대화 주제를 반영한 간결하고 매력적인 제목]
                  - 내용: [500자 이내의 요약]
                각 섹션을 명확히 구분해서 응답해주고, 이모지를 포함해 재밌는 요소를 넣어주세요.
        """
        
        let parameters = createParameters(userContent: text)
        
        return try await withCheckedThrowingContinuation { continuation in
            // requestModifier를 사용하여 timeoutInterval 설정
            AF.request(endpoint,
                       method: .post,
                       parameters: parameters,
                       encoding: JSONEncoding.default,
                       headers: defaultHeaders,
                       requestModifier: { $0.timeoutInterval = 300 }) // 타임아웃을 120초(2분)으로 늘림
            .validate()
            .responseDecodable(of: ChatGPTResponse.self) { response in
                switch response.result {
                case .success(let gptResponse):
                    print("=========GPT Response=========")
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
        analysisData.summaries = []      // 빈 배열로 초기화
        
        // 1. title 추출 시도
        if let titleMatch = content.range(of: "제목: ([^\n]+)", options: .regularExpression) {
            let titleRange = titleMatch.lowerBound ..< titleMatch.upperBound
            let titleString = String(content[titleRange])
            analysisData.title = titleString.replacingOccurrences(of: "제목: ", with: "")
                .replacingOccurrences(of: "\"", with: "")
        }
        
        // 2. contents 추출 시도
        do {
            let lines = content.components(separatedBy: "\n")
            var issues = [String]()
            var capturingIssues = false
            var inMainSection = false
            
            for (index, line) in lines.enumerated() {
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                
                // 쟁점 섹션 시작 감지 (여러 가능한 형식)
                if trimmedLine.contains("주요 쟁점:") ||
                    trimmedLine.contains("쟁점 추출") ||
                    trimmedLine.contains("대화 요약 제목 및 쟁점") {
                    capturingIssues = true
                    inMainSection = true
                    continue
                }
                
                // 다음 섹션 시작 감지 (쟁점 섹션 종료)
                if inMainSection && (
                    trimmedLine.contains("싸움의 격한 정도") ||
                    trimmedLine.contains("각 쟁점에 대한 poll") ||
                    trimmedLine.contains("poll 생성")
                ) {
                    inMainSection = false
                    break
                }
                
                // 쟁점 항목 캡처 - 다양한 형식 지원
                if inMainSection && (
                    trimmedLine.matches(of: /- 쟁점 \d+:/).first != nil ||
                    trimmedLine.matches(of: /쟁점 \d+:/).first != nil ||
                    trimmedLine.matches(of: /- 쟁점 \d+\./).first != nil ||
                    trimmedLine.matches(of: /\d+\)/).first != nil
                ) {
                    // 번호 추출 시도
                    var issueNumber = issues.count + 1
                    var issueContent = ""
                    
                    // 번호와 콜론/점/괄호 이후의 내용 추출
                    if let numberRange = trimmedLine.firstRange(of: /\d+/) {
                        issueNumber = Int(trimmedLine[numberRange]) ?? issueNumber
                        
                        // 콜론(:) 또는 닫는 괄호()) 이후의 텍스트를 쟁점 내용으로 추출
                        if let contentRange = trimmedLine.range(of: "(?::|\\.|\\))\\s*(.+)", options: .regularExpression) {
                            let startIndex = trimmedLine.index(contentRange.lowerBound, offsetBy: 1)
                            issueContent = String(trimmedLine[startIndex...]).trimmingCharacters(in: .whitespacesAndNewlines)
                        } else if let contentRange = trimmedLine.range(of: "\\d+:?\\s*(.+)", options: .regularExpression) {
                            issueContent = String(trimmedLine[contentRange.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
                        } else {
                            // "- 쟁점 1: 내용" 형식에서 내용 부분 추출
                            let parts = trimmedLine.split(separator: ":")
                            if parts.count > 1 {
                                issueContent = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                            } else {
                                // 내용 부분을 찾지 못한 경우, 전체 라인 사용
                                issueContent = trimmedLine
                            }
                        }
                        
                        if !issueContent.isEmpty {
                            issues.append("\(issueNumber). \(issueContent)")
                        }
                    }
                }
            }
            
            // 첫 번째 방법으로 쟁점을 찾지 못한 경우, 다른 패턴으로 재시도
            if issues.isEmpty {
                print("첫 번째 방법으로 쟁점을 찾지 못했습니다. 다른 방법 시도 중...")
                
                // 단순히 "- 쟁점" 또는 "쟁점" 이 포함된 줄 찾기
                for line in lines {
                    let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // "- 쟁점" 패턴 확인 (번호가 없어도 처리)
                    if trimmedLine.contains("- 쟁점") || (trimmedLine.contains("쟁점") && !trimmedLine.contains("쟁점별") && !trimmedLine.contains("각 쟁점")) {
                        if let colonIndex = trimmedLine.firstIndex(of: ":") {
                            let content = trimmedLine[colonIndex...].dropFirst().trimmingCharacters(in: .whitespacesAndNewlines)
                            if !content.isEmpty {
                                issues.append("\(issues.count + 1). \(content)")
                            }
                        } else if trimmedLine.contains("-") {
                            // "- 쟁점 내용" 형식 (콜론 없음)
                            let parts = trimmedLine.split(separator: "-")
                            if parts.count > 1 {
                                let content = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                                if content.contains("쟁점") {
                                    let subparts = content.split(separator: " ", maxSplits: 1)
                                    if subparts.count > 1 {
                                        issues.append("\(issues.count + 1). \(subparts[1])")
                                    }
                                } else {
                                    issues.append("\(issues.count + 1). \(content)")
                                }
                            }
                        }
                    }
                }
            }
            
            // 그래도 쟁점을 찾지 못한 경우, Poll의 제목을 대체 쟁점으로 사용
            if issues.isEmpty && !analysisData.polls!.isEmpty {
                print("쟁점을 직접 찾지 못했습니다. Poll 제목을 쟁점으로 사용합니다.")
                for (index, poll) in analysisData.polls!.enumerated() {
                    issues.append("\(index + 1). \(poll.title)")
                }
            }
            
            if !issues.isEmpty {
                analysisData.contents = issues.joined(separator: "\n")
                print("최종 추출된 쟁점 내용: \(issues)")
            } else {
                // 기본 내용 설정
                analysisData.contents = "쟁점을 추출할 수 없습니다."
                print("모든 방법으로 쟁점 추출 실패. 응답 내용을 확인해 보세요.")
            }
        } catch {
            print("쟁점 추출 중 오류 발생: \(error)")
            analysisData.contents = "쟁점 분석 처리 중 오류 발생"
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
                    pollData.myOpinion = nsString.substring(with: match.range(at: 3))
                        .replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    pollData.yourOpinion = nsString.substring(with: match.range(at: 4))
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
        
        // 5. Summaries 추출 (다양한 형식 대응)
        analysisData.summaries = []

        // 요약 섹션을 찾기 위한 여러 패턴 시도
        let summaryPatterns = [
            "커뮤니티에 게시글로 올라갈 요약본",
            "게시글 작성",
            "커뮤니티 게시글",
            "4. 커뮤니티에 게시글로 올라갈 요약본",
            "4. 게시글 작성",
            "4. 커뮤니티 게시글"
        ]

        // 패턴 매칭 시도 및 요약 추출
        var foundSummarySection = false

        for pattern in summaryPatterns {
            do {
                // 단순한 문자열 검색으로 패턴 찾기
                if let patternRange = content.range(of: pattern) {
                    // 해당 패턴부터 끝까지의 텍스트 추출
                    let summarySection = String(content[patternRange.upperBound...])
                    
                    // 제목 줄 찾기
                    let titleLines = summarySection.components(separatedBy: "\n").filter { line in
                        return line.contains("제목:") && !line.contains("쟁점 제목:")
                    }
                    
                    // 최대 2개의 요약만 추출
                    let processedTitles = titleLines.prefix(2)
                    
                    for (index, titleLine) in processedTitles.enumerated() {
                        if let titleStartIndex = titleLine.range(of: "제목:")?.upperBound {
                            // 제목 추출
                            let title = String(titleLine[titleStartIndex...])
                                .replacingOccurrences(of: "\"", with: "")
                                .replacingOccurrences(of: "-", with: "")
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            // 제목 라인 이후의 내용 라인 찾기
                            let lineIndex = summarySection.components(separatedBy: "\n").firstIndex(of: titleLine) ?? 0
                            let contentLines = summarySection.components(separatedBy: "\n").dropFirst(lineIndex + 1)
                            
                            // 내용 라인 찾기
                            if let contentLine = contentLines.first(where: { $0.contains("내용:") }) {
                                if let contentStartIndex = contentLine.range(of: "내용:")?.upperBound {
                                    // 내용 추출 시작
                                    var content = String(contentLine[contentStartIndex...])
                                        .replacingOccurrences(of: "\"", with: "")
                                        .replacingOccurrences(of: "-", with: "")
                                        .trimmingCharacters(in: .whitespacesAndNewlines)
                                    
                                    // 다음 제목 라인까지 추가 내용 추출
                                    let contentLineIndex = contentLines.firstIndex(of: contentLine) ?? 0
                                    let remainingLines = Array(contentLines.dropFirst(contentLineIndex + 1))
                                    
                                    var additionalContent = ""
                                    for line in remainingLines {
                                        if line.contains("제목:") && !line.contains("쟁점 제목:") {
                                            break
                                        }
                                        let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                                        if !trimmedLine.isEmpty {
                                            additionalContent += " " + trimmedLine
                                        }
                                    }
                                    
                                    // 최종 내용에 추가 내용 합치기
                                    if !additionalContent.isEmpty {
                                        content += additionalContent
                                    }
                                    
                                    // SummaryData 생성
                                    let isCurrentUser = (index == 0) // 첫 번째 요약은 현재 사용자 것으로 가정
                                    let summary = SummaryData(title: title, contents: content, date: Date(), isCurrentUser: isCurrentUser)
                                    analysisData.summaries!.append(summary)
                                    
                                    print("요약 추출 성공! 제목: \(title)")
                                }
                            }
                        }
                    }
                    
                    if !analysisData.summaries!.isEmpty {
                        foundSummarySection = true
                        break
                    }
                }
            } catch {
                print("요약 검색 오류: \(error)")
                continue
            }
        }

        // 백업 전략: 단순 텍스트 구분으로 추출
        if !foundSummarySection {
            print("첫 번째 방법으로 요약을 찾지 못했습니다. 백업 방법 시도 중...")
            
            // 전체 텍스트에서 "제목:" 줄 찾기
            let lines = content.components(separatedBy: .newlines)
            var currentTitle: String? = nil
            var collectingContent = false
            var currentContent = ""
            var summaries: [(title: String, content: String)] = []
            
            for (i, line) in lines.enumerated() {
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if trimmedLine.contains("제목:") && !trimmedLine.contains("쟁점 제목:") {
                    // 이전 제목-내용 저장
                    if let title = currentTitle, !currentContent.isEmpty {
                        summaries.append((title: title, content: currentContent))
                        currentContent = ""
                    }
                    
                    // 새 제목 추출
                    if let titleStart = trimmedLine.range(of: "제목:")?.upperBound {
                        currentTitle = String(trimmedLine[titleStart...])
                            .replacingOccurrences(of: "\"", with: "")
                            .replacingOccurrences(of: "-", with: "")
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        collectingContent = false
                    }
                }
                else if trimmedLine.contains("내용:") && currentTitle != nil {
                    // 내용 시작
                    if let contentStart = trimmedLine.range(of: "내용:")?.upperBound {
                        currentContent = String(trimmedLine[contentStart...])
                            .replacingOccurrences(of: "\"", with: "")
                            .replacingOccurrences(of: "-", with: "")
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        collectingContent = true
                    }
                }
                else if collectingContent && currentTitle != nil {
                    // 다음 제목이나 쟁점을 만날 때까지 내용 수집
                    if trimmedLine.contains("제목:") || trimmedLine.contains("쟁점 제목:") {
                        collectingContent = false
                        continue
                    }
                    
                    if !trimmedLine.isEmpty {
                        currentContent += " " + trimmedLine
                    }
                }
            }
            
            // 마지막 항목 처리
            if let title = currentTitle, !currentContent.isEmpty {
                summaries.append((title: title, content: currentContent))
            }
            
            // 최대 2개의 요약 저장
            for (index, summary) in summaries.prefix(2).enumerated() {
                let isCurrentUser = (index == 0)
                let summaryData = SummaryData(title: summary.title, contents: summary.content, date: Date(), isCurrentUser: isCurrentUser)
                analysisData.summaries!.append(summaryData)
                print("백업 방법으로 요약 추출 성공! 제목: \(summary.title)")
            }
            
            foundSummarySection = !analysisData.summaries!.isEmpty
        }

        // 요약 데이터가 없는 경우 기본 요약 추가
        if analysisData.summaries!.isEmpty {
            print("모든 방법으로 요약 추출 실패. 기본 요약 추가")
            let defaultSummary1 = SummaryData(title: "요약 추출 실패", contents: "요약글 추출에 실패했습니다 😢", date: Date(), isCurrentUser: true)
            let defaultSummary2 = SummaryData(title: "요약 추출 실패", contents: "요약글 추출에 실패했습니다 😢", date: Date(), isCurrentUser: false)
            analysisData.summaries!.append(defaultSummary1)
            analysisData.summaries!.append(defaultSummary2)
        }
        
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
                    poll.myOpinion = trimmedLine.replacingOccurrences(of: "나의 의견:", with: "")
                        .replacingOccurrences(of: "-", with: "")
                        .replacingOccurrences(of: "\"", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    
                } else if trimmedLine.contains("상대방 의견:") {
                    poll.yourOpinion = trimmedLine.replacingOccurrences(of: "상대방 의견:", with: "")
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
