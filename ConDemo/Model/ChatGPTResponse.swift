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
    private func convertToAnalysisData(_ response: ChatGPTResponse) throws -> AnalysisData {
        guard let content = response.choices.first?.message.content else {
            throw NSError(domain: String(describing: ChatGPTManager.self), code: 1, userInfo:
            [NSLocalizedDescriptionKey: "ChatGPT 응답 내용이 없습니다"])
        }
        
        // ChatGPT 응답 내용 출력
        print("원본 ChatGPT 응답 내용:")
        print(content)
        
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
                    if !line.contains("쟁점 제목:") {
                        let cleanLine = line.replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespaces)
                        issues.append(cleanLine)
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
        if let levelMatch = content.range(of: "싸움의 격한 정도: *(\\d+)", options: .regularExpression) {
            let levelString = String(content[levelMatch])
            let numbersOnly = levelString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            if let level = Int(numbersOnly), level >= 1 && level <= 9 {
                analysisData.level = level
            }
        } else if let levelMatch = content.range(of: "격한 정도는 '(\\d+)단계'", options: .regularExpression) {
            let levelString = String(content[levelMatch])
            let numbersOnly = levelString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            if let level = Int(numbersOnly), level >= 1 && level <= 9 {
                analysisData.level = level
            }
        } else if let levelMatch = content.range(of: "격한 정도는 *(\\d+)", options: .regularExpression) {
            let levelString = String(content[levelMatch])
            let numbersOnly = levelString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            if let level = Int(numbersOnly), level >= 1 && level <= 9 {
                analysisData.level = level
            }
        }
        
        // 4. poll 추출 시도 - 개선된 정규식
        do {
            // 문자열 전체를 먼저 분석하여 "쟁점 제목:"으로 시작하는 섹션 찾기
            let sections = content.components(separatedBy: "쟁점 제목:")
            
            // 첫 번째는 건너뛰기 (헤더 부분)
            for section in sections.dropFirst() {
                var pollData = PollData()
                pollData.date = Date()
                
                // 섹션 내 각 줄 분석
                let lines = section.components(separatedBy: "\n")
                
                // 제목 추출 (첫 번째 줄)
                if !lines.isEmpty {
                    pollData.title = lines[0].replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                }
                
                // 나머지 필드 추출
                var contents = ""
                var his = ""
                var hers = ""
                var options = ""
                
                for line in lines {
                    if line.contains("내용:") {
                        contents = line.replacingOccurrences(of: "내용:", with: "").replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    } else if line.contains("나의 의견:") {
                        his = line.replacingOccurrences(of: "나의 의견:", with: "").replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    } else if line.contains("상대방 의견:") {
                        hers = line.replacingOccurrences(of: "상대방 의견:", with: "").replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    } else if line.contains("옵션:") {
                        options = line.replacingOccurrences(of: "옵션:", with: "").replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                }
                
                pollData.contents = contents
                pollData.his = his
                pollData.hers = hers
                
                // 옵션 처리
                let optionLabels = ["A", "B", "C", "D"]
                let rawOptions = options.components(separatedBy: ", ")
                
                pollData.options = []
                for i in 0 ..< min(4, rawOptions.count) {
                    let option = rawOptions[i].trimmingCharacters(in: .whitespacesAndNewlines)
                    if !option.isEmpty {
                        pollData.options.append("\(optionLabels[i]). \(option)")
                    }
                }
                
                // 최소한의 유효성 검사 후 추가
                if !pollData.title.isEmpty && !pollData.options.isEmpty {
                    analysisData.polls!.append(pollData)
                }
            }
            
            print("파싱된 Poll 개수: \(analysisData.polls!.count)")
            
            // 백업 방법: 여전히 Poll이 추출되지 않은 경우
            if analysisData.polls!.isEmpty {
                // 정규식 패턴 수정
                let pollPattern = "쟁점 제목:\\s*([^\\n]+)[\\s\\n]*내용:\\s*([^\\n]+)[\\s\\n]*나의 의견:\\s*([^\\n]+)[\\s\\n]*상대방 의견:\\s*([^\\n]+)[\\s\\n]*옵션:\\s*([^\\n]+)"
                
                let pollRegex = try NSRegularExpression(pattern: pollPattern, options: [.dotMatchesLineSeparators])
                let nsString = content as NSString
                let pollMatches = pollRegex.matches(in: content, options: [], range: NSRange(location: 0, length: nsString.length))
                
                print("정규식으로 찾은 Poll 수: \(pollMatches.count)")
                
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
            }
            
            // 백업 방법 3: 수동 샘플 데이터 생성
            if analysisData.polls!.isEmpty && !analysisData.title.isEmpty {
                print("Poll 생성 실패. 샘플 데이터 사용")
                
                // 예제 데이터로 최소 1개 Poll 생성
                var pollData = PollData()
                pollData.title = "대화 관련 투표"
                pollData.contents = "대화 내용에 대한 의견을 선택해주세요"
                pollData.his = "내 의견"
                pollData.hers = "상대방 의견"
                pollData.options = ["A. 의견 1", "B. 의견 2", "C. 의견 3", "D. 의견 4"]
                pollData.date = Date()
                
                analysisData.polls!.append(pollData)
            }
        } catch {
            print("Poll 정규식 오류: \(error)")
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
        
        // 최종 데이터 확인
        print("분석 결과:")
        print("제목: \(analysisData.title)")
        print("내용: \(analysisData.contents)")
        print("레벨: \(analysisData.level)")
        print("Poll 개수: \(analysisData.polls?.count ?? 0)")
        print("Summary: \(analysisData.summary?.title ?? "없음")")
        
        return analysisData
    }
}
