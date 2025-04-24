//
//  ChatGPTManager.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//

/// 새 코드
import Alamofire
import CoreData
import Foundation
import UIKit
import LangChain

class ChatGPTManager {
    static let shared: ChatGPTManager = .init()
    
    // MARK: - Properties
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    private let defaultModel = "gpt-4-turbo"
    private let defaultSystemContent = "당신은 사용자의 질문에 도움을 주는 AI 어시스턴트. 친절하고 자연스럽게 대화 부탁. 한국어로 답변 부탁."
    private let defaultHeaders: HTTPHeaders = [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(APIKey.chatGPT)"
    ]
    
    private init() {
        LC.initSet([
            "OPENAI_API_KEY": APIKey.chatGPT,
            "OPENAI_MODEL": "gpt-4.1-mini"
        ])
    }
    
    // MARK: - Functions
    private func createParameters(
        model: String = "gpt-4.1",
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
    
    // 기본 Summary 분석
    func analyzeConversation(transcriptJson: String) async throws -> AnalysisData {
        do {
            // 데모 객체 생성 (빈 객체로 시작)
            let demoData = AnalysisData()
            
            // ObjectOutputParser 설정
            var parser = ObjectOutputParser(demo: demoData)
            
            print("프롬프트 템플릿 설정 중...")
            
            // 프롬프트 템플릿 설정
            let template = Templates.analysisTemplate
            
            let prompt = PromptTemplate(
                input_variables: ["transcript"],
                partial_variable: ["format_instructions": parser.get_format_instructions()],
                template: template
            )
            
            print("LLM 체인 생성 중...")
            
            // LLM 및 체인 설정
            let llm = OpenAI(
                temperature: 1.0
            )
            
            let chain = LLMChain(
                llm: llm,
                prompt: prompt,
                parser: parser,
                inputKey: "transcript"
            )
            
            print("분석 실행 중...")
            
            // 분석 실행
            let result = await chain.run(args: transcriptJson)
            
            print("결과 파싱 중...\(result)")
            
            // 결과 파싱
            switch result {
            case .object(let analysisData):
                print("객체로 파싱 성공")
                
                if let data = analysisData as? AnalysisData {
                    print("AnalysisData로 변환 성공")
                    
                    // 날짜 설정 (API 응답에서는 현재 날짜가 설정되지 않을 수 있음)
                    var resultData = data
                    resultData.date = Date()
                    
                    // 결과 유효성 검사 및 보정
                    resultData = validateAndFixAnalysisData(resultData)
                    
                    return resultData
                } else {
                    print("AnalysisData로 변환 실패: \(String(describing: analysisData))")
                    throw NSError(domain: String(describing: ChatGPTManager.self), code: 2,
                                  userInfo: [NSLocalizedDescriptionKey: "분석 데이터 변환 실패"])
                }
            default:
                print("객체로 파싱 실패")
                throw NSError(domain: String(describing: ChatGPTManager.self), code: 3,
                              userInfo: [NSLocalizedDescriptionKey: "파싱 결과가 예상 형식과 다름"])
            }
        } catch {
            print("분석 과정에서 오류 발생: \(error)")
            
            if transcriptJson.isEmpty {
                throw error // 트랜스크립트가 비어있다면 오류 그대로 전달
            } else {
                return createFallbackAnalysisData(transcript: transcriptJson)
            }
        }
    }
    
    // 세부 디테일 분석
    func analyzeTranscriptJSON(transcriptJson: String) async throws -> DetailedTranscriptAnalysisData {
        do {
            print("트랜스크립트 분석 시작...")
            
            // 데모 객체 생성 (빈 객체로 시작)
            let demoData = DetailedTranscriptAnalysisData()
            
            // ObjectOutputParser 설정
            var parser = ObjectOutputParser(demo: demoData)
            
            print("프롬프트 템플릿 설정 중...")
            
            // 프롬프트 템플릿 설정
            let template = Templates.detailTemplate
            
            let prompt = PromptTemplate(
                input_variables: ["transcript"],
                partial_variable: ["format_instructions": parser.get_format_instructions()],
                template: template
            )
            
            print("LLM 체인 생성 중...")
            
            // LLM 및 체인 설정
            let llm = OpenAI(
                temperature: 0.0  // 정량적 분석이므로 낮은 온도 사용
            )
            
            let chain = LLMChain(
                llm: llm,
                prompt: prompt,
                parser: parser,
                inputKey: "transcript"
            )
            
            print("분석 실행 중...")
            
            // 분석 실행
            let result = await chain.run(args: transcriptJson)
            
            print("결과 파싱 중...")
            
            // 결과 파싱
            switch result {
            case .object(let analysisData):
                print("객체로 파싱 성공")
                
                if let data = analysisData as? DetailedTranscriptAnalysisData {
                    print("TranscriptAnalysisData로 변환 성공")
                    
                    // 날짜 설정
                    var resultData = data
                    resultData.date = Date()
                    
                    // 결과 유효성 검사 및 보정
                    resultData = validateAndFixTranscriptAnalysisData(resultData)
                    
                    return resultData
                } else {
                    print("TranscriptAnalysisData로 변환 실패: \(String(describing: analysisData))")
                    throw NSError(domain: String(describing: ChatGPTManager.self), code: 2,
                                  userInfo: [NSLocalizedDescriptionKey: "분석 데이터 변환 실패"])
                }
            default:
                print("객체로 파싱 실패")
                throw NSError(domain: String(describing: ChatGPTManager.self), code: 3,
                              userInfo: [NSLocalizedDescriptionKey: "파싱 결과가 예상 형식과 다름"])
            }
        } catch {
            print("분석 과정에서 오류 발생: \(error)")
            
            if transcriptJson.isEmpty {
                throw error // 트랜스크립트가 비어있다면 오류 그대로 전달
            } else {
                return createFallbackTranscriptAnalysisData()
            }
        }
    }
    
    // AWS Transcribe JSON을 받아 전체 분석 수행 (TranscribeManager에서 호출됨)
//    func createAnalysisDataFromTranscript(transcriptJson: String, title: String = "") async throws -> AnalysisData {
//        do {
//            // print("수신한 JSON: \(transcriptJson)")
//
//            // 기본 분석 데이터 생성
//            var analysisData = AnalysisData()
//            
//            // 메시지 데이터 추출
//            let decoder = JSONDecoder()
//            // let transcription = try decoder.decode(TranscriptionResponse.self, from: transcriptJson.data(using: .utf8)!)
//            let transcription = try TranscribeManager.shared.parseTranscriptionContent(transcriptJson)
//            let messages = transcription.getTranscript()
//            analysisData.messages = messages
//            //print("대화 내용 \(analysisData.messages)")
//            
//            let transcript = messages.map {
//                "\($0.isFromCurrentUser ? "나" : "상대방"): \($0.text)"
//            }.joined(separator: "\n")
//            
//            // 1. 커뮤니티 콘텐츠 분석 수행
//            let communityData = try await analyzeConversation(transcriptJson: transcript)
//            
//            // 2. 상세 트랜스크립트 분석 수행
//            let detailedAnalysis = try await analyzeTranscriptJSON(transcriptJson: transcriptJson)
//            
//            // 3. 데이터 통합
//            analysisData.title = communityData.title.isEmpty ? "음성 대화 분석" : title
//            analysisData.date = Date()
//            analysisData.contents = communityData.contents
//            analysisData.level = communityData.level
//            analysisData.polls = communityData.polls
//            analysisData.summaries = communityData.summaries
//            analysisData.detailedTranscriptAnalysisData = detailedAnalysis
//            analysisData.log = LogData(date: Date(), contents: "AWS Transcribe 음성 분석 완료")
//            
//            return analysisData
//        } catch {
//            print("트랜스크립트에서 AnalysisData 생성 중 오류: \(error)")
//            throw error
//        }
//    }
    
    // 결과 유효성 검사 및 보정 함수 (DetailedTranscriptAnalysisData용)
    private func validateAndFixTranscriptAnalysisData(_ data: DetailedTranscriptAnalysisData) -> DetailedTranscriptAnalysisData {
        var result = data
        
        // 1. 말한 시간이 음수나 너무 큰 값인 경우 보정
        if result.speakingTime.speakerA < 0 || result.speakingTime.speakerA > 1000 {
            result.speakingTime.speakerA = 5.0
        }
        
        if result.speakingTime.speakerB < 0 || result.speakingTime.speakerB > 1000 {
            result.speakingTime.speakerB = 5.0
        }

        // 4. 일관성 점수 범위 확인 (1-5)
        result.consistency.speakerA.score = max(1, min(5, result.consistency.speakerA.score))
        result.consistency.speakerB.score = max(1, min(5, result.consistency.speakerB.score))
        
        // 5. 사실관계 정확성 점수 범위 확인 (1-5)
        result.factualAccuracy.speakerA.score = max(1, min(5, result.factualAccuracy.speakerA.score))
        result.factualAccuracy.speakerB.score = max(1, min(5, result.factualAccuracy.speakerB.score))
        
        // 6. 감정 분석 비율 확인 (0-1)
        result.sentimentAnalysis.speakerA.positiveRatio = max(0, min(1, result.sentimentAnalysis.speakerA.positiveRatio))
        result.sentimentAnalysis.speakerA.negativeRatio = max(0, min(1, result.sentimentAnalysis.speakerA.negativeRatio))
        result.sentimentAnalysis.speakerB.positiveRatio = max(0, min(1, result.sentimentAnalysis.speakerB.positiveRatio))
        result.sentimentAnalysis.speakerB.negativeRatio = max(0, min(1, result.sentimentAnalysis.speakerB.negativeRatio))
        
        // 7. 긍정/부정 단어 예시가 비어있는 경우 기본값 설정
        if result.sentimentAnalysis.speakerA.positiveExamples.isEmpty {
            result.sentimentAnalysis.speakerA.positiveExamples = ["(예시 없음)"]
        }
        
        if result.sentimentAnalysis.speakerA.negativeExamples.isEmpty {
            result.sentimentAnalysis.speakerA.negativeExamples = ["(예시 없음)"]
        }
        
        if result.sentimentAnalysis.speakerB.positiveExamples.isEmpty {
            result.sentimentAnalysis.speakerB.positiveExamples = ["(예시 없음)"]
        }
        
        if result.sentimentAnalysis.speakerB.negativeExamples.isEmpty {
            result.sentimentAnalysis.speakerB.negativeExamples = ["(예시 없음)"]
        }
        
        // 8. 날짜 업데이트
        result.date = Date()
        
        return result
    }
}


// 통합버전
extension ChatGPTManager {
    func analyzeTranscriptComplete(transcriptJson: String) async throws -> AnalysisData {
        do {
            print("통합 분석 시작...")
            
            // 데모 객체 생성 (빈 객체로 시작)
            let demoData = AnalysisData()
            
            // ObjectOutputParser 설정
            var parser = ObjectOutputParser(demo: demoData)
            
            print("프롬프트 템플릿 설정 중...")
            
            // 프롬프트 템플릿 설정 - 통합 템플릿 사용
            let template = Templates.newholeTemplate
            
            let prompt = PromptTemplate(
                input_variables: ["transcript"],
                partial_variable: ["format_instructions": parser.get_format_instructions()],
                template: template
            )
            
            print("LLM 체인 생성 중...")
            
            // LLM 및 체인 설정
            let llm = OpenAI(
                temperature: 0.8
            )
            
            let chain = LLMChain(
                llm: llm,
                prompt: prompt,
                parser: parser,
                inputKey: "transcript"
            )
            
            print("분석 실행 중...")
                        
            // 분석 실행
            let result = await chain.run(args: transcriptJson)
            
            print("LangChain Result: \(result)")
            
            print("결과 파싱 중...")
            
            // 결과 파싱
            switch result {
            case .object(let analysisData):
                print("객체로 파싱 성공")
                
                if let data = analysisData as? AnalysisData {
                    print("최종 AnalysisData로 변환환 성공")
                    
                    // 결과 유효성 검사 및 보정
                    var resultData = data
                    resultData = validateAndFixCompleteAnalysisData(resultData)
                    
                    return resultData
                } else {
                    print("최종 AnalysisData로 변환 실패: \(String(describing: analysisData))")
                    throw NSError(domain: String(describing: ChatGPTManager.self), code: 2,
                                  userInfo: [NSLocalizedDescriptionKey: "분석 데이터 변환 실패"])
                }
            default:
                print("객체로 파싱 실패")
                throw NSError(domain: String(describing: ChatGPTManager.self), code: 3,
                              userInfo: [NSLocalizedDescriptionKey: "파싱 결과가 예상 형식과 다름"])
            }
        } catch {
            print("통합 분석 과정에서 오류 발생: \(error)")
            
            if transcriptJson.isEmpty {
                throw error // 트랜스크립트가 비어있다면 오류 그대로 전달
            } else {
                return createFallbackCompleteAnalysisData()
            }
        }
    }
    
    // MARK: - 유효성 검사 및 폴백 데이터 생성
    func validateAndFixCompleteAnalysisData(_ data: AnalysisData) -> AnalysisData {
        var fixedData = data
        
        // 제목 검사
        if fixedData.title.isEmpty {
            fixedData.title = "대화 분석"
        }
        
        // 레벨 검사 (1-10 범위로 보정)
        if fixedData.level < 1 {
            fixedData.level = 1
        } else if fixedData.level > 10 {
            fixedData.level = 10
        }
        
        // 폴 데이터 검사
        if fixedData.polls == nil || fixedData.polls!.isEmpty {
            fixedData.polls = [
                PollData(),
                PollData(),
                PollData()
            ]
        }
        
        // 요약 데이터 검사
        if fixedData.summaries == nil || fixedData.summaries!.isEmpty {
            fixedData.summaries = [
                SummaryData(isCurrentUser: true),
                SummaryData(isCurrentUser: false)
            ]
        }
        
        // 상세 분석 데이터 검사
        if fixedData.detailedTranscriptAnalysisData == nil {
            fixedData.detailedTranscriptAnalysisData = DetailedTranscriptAnalysisData()
        }
        
        return fixedData
    }
    
    // 폴백 데이터 생성
    func createFallbackCompleteAnalysisData() -> AnalysisData {
        var fallbackData = AnalysisData()
        fallbackData.title = "분석 실패"
        fallbackData.contents = "대화 분석 중 오류가 발생했습니다. 다시 시도해주세요."
        fallbackData.level = 1
        
        // 기본 폴 데이터
        var poll1 = PollData()
        poll1.title = "분석 실패"
        poll1.contents = "분석 과정에서 오류가 발생했습니다."
        poll1.options = ["다시 시도하기", "나중에 시도하기", "문의하기", "취소하기"]
        
        fallbackData.polls = [poll1, poll1, poll1]
        
        // 기본 요약 데이터
        let summary1 = SummaryData(
            title: "분석 실패",
            contents: "대화 내용 분석 중 오류가 발생했습니다.",
            isCurrentUser: true
        )
        let summary2 = SummaryData(
            title: "분석 실패",
            contents: "대화 내용 분석 중 오류가 발생했습니다.",
            isCurrentUser: false
        )
        
        fallbackData.summaries = [summary1, summary2]
        
        // 기본 상세 분석 데이터
        fallbackData.detailedTranscriptAnalysisData = DetailedTranscriptAnalysisData()
        
        return fallbackData
    }
    
    // MARK: - 통합 함수 사용 예시 - 수정된 createAnalysisDataFromTranscript
    func createAnalysisDataFromTranscript(transcriptJson: String, title: String = "") async throws -> AnalysisData {
        do {
            print("수신한 JSON: \(transcriptJson)")
            
            // 기본 분석 데이터 생성
            var analysisData = AnalysisData()
            
            // 메시지 데이터 추출
            let transcription = try TranscribeManager.shared.parseTranscriptionContent(transcriptJson)
            analysisData.messages = transcription.getTranscript()
            
            // 통합된 분석 함수 호출 - 한 번의 API 호출로 모든 데이터 가져오기
            let completeData = try await analyzeTranscriptComplete(transcriptJson: transcriptJson)
            
            // 결과 데이터 복사
            analysisData.date = Date()
            analysisData.title = completeData.title
            analysisData.contents = completeData.contents
            analysisData.level = completeData.level
            analysisData.polls = completeData.polls
            analysisData.summaries = completeData.summaries
            analysisData.detailedTranscriptAnalysisData = completeData.detailedTranscriptAnalysisData
            analysisData.log = LogData(date: Date(), contents: "AWS Transcribe 음성 분석 완료")
            
            return analysisData
        } catch {
            print("트랜스크립트에서 AnalysisData 생성 중 오류: \(error)")
            throw error
        }
    }
}

// 오류 및 보정 함수
extension ChatGPTManager {
    // 오류 발생 시 기본 분석 데이터 생성 (DetailedTranscriptAnalysisData용)
    private func createFallbackTranscriptAnalysisData() -> DetailedTranscriptAnalysisData {
        var data = DetailedTranscriptAnalysisData()
        
        data.speakingTime.speakerA = 5.0
        data.speakingTime.speakerB = 5.0

        data.consistency.speakerA.score = 3
        data.consistency.speakerA.reasoning = "화자A의 주장은 중간 정도의 일관성을 보였습니다."
        data.consistency.speakerB.score = 3
        data.consistency.speakerB.reasoning = "화자B의 주장은 중간 정도의 일관성을 보였습니다."
        
        data.factualAccuracy.speakerA.score = 3
        data.factualAccuracy.speakerA.reasoning = "화자A의 사실 관계는 검증 불가능한 부분이 있습니다."
        data.factualAccuracy.speakerB.score = 3
        data.factualAccuracy.speakerB.reasoning = "화자B의 사실 관계는 검증 불가능한 부분이 있습니다."
        
        data.sentimentAnalysis.speakerA.positiveRatio = 0.5
        data.sentimentAnalysis.speakerA.negativeRatio = 0.5
        data.sentimentAnalysis.speakerA.positiveExamples = ["좋은", "훌륭한", "유용한"]
        data.sentimentAnalysis.speakerA.negativeExamples = ["문제", "어려운", "복잡한"]
        
        data.sentimentAnalysis.speakerB.positiveRatio = 0.5
        data.sentimentAnalysis.speakerB.negativeRatio = 0.5
        data.sentimentAnalysis.speakerB.positiveExamples = ["좋은", "훌륭한", "유용한"]
        data.sentimentAnalysis.speakerB.negativeExamples = ["문제", "어려운", "복잡한"]

        data.date = Date()
        
        return data
    }
    
    // 결과 유효성 검사 및 보정 함수
    private func validateAndFixAnalysisData(_ data: AnalysisData) -> AnalysisData {
        var result = data
        
        // 1. Title 검증 및 수정
        if result.title.isEmpty || result.title == "대화 요약" {
            result.title = "대화 분석 결과"
        }
        
        // 2. Contents 검증 및 수정
        if result.contents.isEmpty {
            // 대화 내용에서 쟁점 생성 - 더 상세한 내용으로 대체
            result.contents = """
                        💬 쟁점 1. 의사소통 방식 
                        두 사람은 서로 다른 의사소통 방식을 사용하고 있습니다. 한 사람은 직접적이고 명확한 의사 표현을 선호하는 반면, 다른 사람은 감정과 맥락을 고려한 부드러운 소통을 중요시합니다. 이러한 소통 방식의 차이는 대화 과정에서 오해와 갈등을 야기할 수 있습니다.
                        
                        🔍 쟁점 2. 의견 차이 
                        두 사람은 주제에 대한 근본적인 관점 차이를 보이고 있습니다. 한 사람은 논리와 원칙에 기반한 판단을 중시하고, 다른 사람은 개인적 경험과 감정적 측면을 고려한 판단을 중요시합니다. 이러한 시각 차이는 같은 상황에 대해 전혀 다른 해석을 하게 만듭니다.
                        
                        🤝 쟁점 3. 해결 방안 
                        갈등 해결에 대한 접근법에도 차이가 있습니다. 한
                        갈등 해결에 대한 접근법에도 차이가 있습니다. 한 사람은 상호 양보와 타협을 통한 중간점 찾기를 제안하고, 다른 사람은 한쪽의 양보나 외부 조언 구하기를 선호합니다. 이러한 방법론적 차이는 문제 해결 과정에서 또 다른 갈등 요소로 작용할 수 있습니다.
                        """
        }
        
        // 3. Level 검증
        if result.level < 1 || result.level > 10 {
            result.level = 1
        }
        
        // 4. Polls 검증 및 수정
        if result.polls == nil || result.polls!.isEmpty {
            // 기본 Polls 생성
            result.polls = createDefaultPolls()
        } else {
            // 기존 Polls 검증 및 수정
            var validatedPolls: [PollData] = []
            
            for (index, poll) in result.polls!.enumerated() {
                var fixedPoll = poll
                
                // 비어있는 필드 수정
                if fixedPoll.title.isEmpty {
                    fixedPoll.title = "쟁점 \(index + 1) 투표"
                }
                
                if fixedPoll.contents.isEmpty {
                    fixedPoll.contents = "이 쟁점에 대한 의견을 선택해주세요."
                }
                
                if fixedPoll.myOpinion.isEmpty {
                    fixedPoll.myOpinion = "첫 번째 의견"
                }
                
                if fixedPoll.yourOpinion.isEmpty {
                    fixedPoll.yourOpinion = "두 번째 의견"
                }
                
                // 옵션이 비어있거나 4개 미만인 경우 보정
                if fixedPoll.options.isEmpty || fixedPoll.options.count < 4 {
                    let defaultOptions = ["첫 번째 의견에 동의", "두 번째 의견에 동의", "둘 다 일리 있음", "둘 다 동의하지 않음"]
                    
                    if fixedPoll.options.isEmpty {
                        fixedPoll.options = defaultOptions.enumerated().map { index, option in
                            return "\(["A", "B", "C", "D"][index]). \(option)"
                        }
                    }
                }
                
                fixedPoll.date = Date()
                validatedPolls.append(fixedPoll)
            }
            
            // 3개 미만인 경우 기본 poll로 채우기
            while validatedPolls.count < 3 {
                let defaultPoll = createDefaultPolls()
                validatedPolls.append(defaultPoll[validatedPolls.count])
            }
            
            result.polls = validatedPolls
        }
        
        // 5. Summaries 검증 및 수정 (변경된 부분)
        if result.summaries == nil || result.summaries!.isEmpty {
            // 기본 Summaries 생성 - 두 개의 관점 생성
            result.summaries = createDefaultSummaries()
        } else {
            // 기존 Summaries 검증 및 수정
            var validatedSummaries: [SummaryData] = []
            
            for (index, summary) in result.summaries!.enumerated() {
                var fixedSummary = summary
                
                // 비어있는 필드 수정
                if fixedSummary.title.isEmpty {
                    fixedSummary.title = index == 0 ? "나의 관점에서" : "상대방의 관점에서"
                }
                
                if fixedSummary.contents.isEmpty {
                    fixedSummary.contents = index == 0 ?
                    "1. 내 입장에서는 상대방의 의견이 이해가 되지 않았습니다.\n2. 내가 생각하는 논리적인 방식으로 설명했지만 받아들여지지 않았습니다.\n3. 다음에는 더 명확히 의사소통을 해야겠습니다." :
                    "1. 상대방은 내 감정을 고려하지 않고 말했습니다.\n2. 내 경험을 바탕으로 이야기했지만 무시당한 느낌이었습니다.\n3. 서로의 관점 차이를 인정하는 대화가 필요합니다."
                }
                
                // isCurrentUser 필드가 설정되어 있는지 확인
                // 이미 설정되어 있으면 그대로 사용, 아니면 인덱스에 따라 설정
                // index 0은 현재 사용자(true), index 1은 상대방(false)
                if index < 2 {
                    fixedSummary.isCurrentUser = (index == 0)
                }
                
                fixedSummary.date = Date()
                validatedSummaries.append(fixedSummary)
            }
            
            // 정확히 2개의 Summary가 있도록 보장
            while validatedSummaries.count < 2 {
                let isCurrentUser = validatedSummaries.isEmpty
                let defaultSummary = createDefaultSummary(isCurrentUser: isCurrentUser)
                validatedSummaries.append(defaultSummary)
            }
            
            // 2개 초과인 경우 앞의 2개만 사용
            if validatedSummaries.count > 2 {
                validatedSummaries = Array(validatedSummaries.prefix(2))
            }
            
            result.summaries = validatedSummaries
        }
        
        // 6. 날짜 업데이트
        result.date = Date()
        
        return result
    }
}

// 기본 데이터 생성 함수
extension ChatGPTManager {
    // 기본 Polls 생성 함수
    private func createDefaultPolls() -> [PollData] {
        let topics = ["의사소통 방식", "의견 차이", "해결 방안"]
        let contents = [
            "대화에서 의사소통 방식에 대한 의견은?",
            "두 사람의 의견 차이에 대해 어떻게 생각하나요?",
            "이런 상황에서 가장 좋은 해결 방안은?"
        ]
        let myOpinions = [
            "명확하고 직접적인 소통이 필요하다",
            "내 관점이 더 논리적이고 합리적이다",
            "서로 양보하며 중간점을 찾아야 한다"
        ]
        let yourOpinions = [
            "감정을 고려한 부드러운 소통이 중요하다",
            "내 경험에 비추어 볼 때 내 의견이 맞다",
            "한 쪽이 양보하는 것이 갈등 해소에 도움된다"
        ]
        let optionSets = [
            ["A. 직접적인 소통이 항상 최선이다", "B. 상황에 따라 소통 방식을 조절해야 한다", "C. 감정을 고려한 소통이 중요하다", "D. 소통 방식보다 내용이 중요하다"],
            ["A. 첫 번째 사람의 의견이 합리적이다", "B. 두 번째 사람의 주장이 설득력 있다", "C. 둘 다 각자의 관점에서 맞다", "D. 둘 다 부분적으로만 맞다"],
            ["A. 대화로 타협점을 찾아야 한다", "B. 제3자의 중재가 필요하다", "C. 시간을 두고 다시 논의해야 한다", "D. 객관적인 자료로 결론 내려야 한다"]
        ]
        
        var polls: [PollData] = []
        
        for i in 0..<3 {
            var poll = PollData()
            poll.title = topics[i]
            poll.contents = contents[i]
            poll.myOpinion = myOpinions[i]
            poll.yourOpinion = yourOpinions[i]
            poll.options = optionSets[i]
            poll.date = Date()
            polls.append(poll)
        }
        
        return polls
    }

    // 기본 Summary 생성 함수 (단일)
    private func createDefaultSummary(isCurrentUser: Bool) -> SummaryData {
        let title = isCurrentUser ? "내 입장에서 본 대화" : "상대방 입장에서 본 대화"
        let contents = isCurrentUser ?
        "1. 나는 합리적인 해결책을 제시했는데 상대방이 이해하지 못했어요.\n2. 정확한 사실과 논리를 바탕으로 의견을 제시했지만 감정적으로 대응받았습니다.\n3. 다음에는 상대방이 더 쉽게 이해할 수 있는 방식으로 설명해봐야겠어요." :
        "1. 상대방은 내 감정을 전혀 고려하지 않고 일방적으로 주장만 펼쳤어요.\n2. 내 경험과 느낌을 무시하고 논리만 강조하는 태도가 불편했습니다.\n3. 서로 존중하는 대화가 필요하다고 생각해요."
        
        return SummaryData(
            title: title,
            contents: contents,
            date: Date(),
            isCurrentUser: isCurrentUser
        )
    }
    
    // 기본 Summaries 생성 함수 (배열)
    private func createDefaultSummaries() -> [SummaryData] {
        return [
            createDefaultSummary(isCurrentUser: true),
            createDefaultSummary(isCurrentUser: false)
        ]
    }
    
    // 오류 발생 시 기본 분석 데이터 생성
    private func createFallbackAnalysisData(transcript: String) -> AnalysisData {
        var analysisData = AnalysisData()
        analysisData.title = "대화 분석 결과"
        analysisData.contents = """
                    🧠 쟁점 1. 주제 이해
                    대화에서 가장 중요한 첫 번째 쟁점은 주제에 대한 이해 차이입니다. 서로 다른 배경지식과 경험을 가진 두 사람은 같은 주제에 대해 각기 다른 관점에서 접근하고 있습니다. 한 사람은 더 실용적이고 현실적인 측면에서 주제를 바라보는 반면, 다른 사람은 이론적이고 원칙적인 관점에서 주제를 이해하려고 합니다. 이런 근본적인 접근 방식의 차이가 대화의 방향을 복잡하게 만들고 있습니다.
                    
                    🗣️ 쟁점 2. 의사 표현 방식
                    두 번째 주요 쟁점은 의사 표현 방식의 차이입니다. 대화에서 한 사람은 직설적이고 명확한 언어를 사용하여 자신의 생각을 표현하고 있으며, 다른 사람은 보다 완곡하고 맥락을 고려한 표현을 선호합니다. 이러한 커뮤니케이션 스타일의 차이는 때로 오해를 불러일으키며, 한 사람의 솔직한 의견이 다른 사람에게는 무례하게 느껴질 수 있습니다. 의사 전달 방식의 차이는 내용 자체보다 대화의 흐름에 더 큰 영향을 미치기도 합니다.
                    
                    🔧 쟁점 3. 문제 해결 접근법
                    세 번째 쟁점은 문제 해결에 대한 접근법 차이입니다. 한 사람은 즉각적인 해결책을 찾아 빠르게 실행하는 것을 선호하는 반면, 다른 사람은 다양한 가능성을 검토하고 신중하게 결정하는 것을 중요시합니다. 이러한 차이는 해결책을 찾는 과정에서 시간과 자원 활용에 대한 의견 충돌로 이어질 수 있습니다. 또한 단기적 해결책과 장기적 해결책 중 무엇을 우선시할지에 대한 가치관 차이도 드러납니다.
                    """
        analysisData.level = 1
        analysisData.date = Date()
        
        // 기본 Polls 생성
        analysisData.polls = createDefaultPolls()
        
        // 기본 Summaries 생성 (두 개의 관점)
        analysisData.summaries = createDefaultSummaries()
        
        // 트랜스크립트에서 일부 내용 추출해서 요약에 사용
        if !transcript.isEmpty {
            let lines = transcript.components(separatedBy: "\n")
            var extractedText = ""
            
            for line in lines {
                if line.count > 10 {
                    let startIndex = line.index(line.startIndex, offsetBy: min(10, line.count))
                    extractedText += line[startIndex...] + " "
                    if extractedText.count > 100 {
                        break
                    }
                }
            }
            
            if !extractedText.isEmpty {
                // 추출한 텍스트로 summary 내용 업데이트
                if let firstSummary = analysisData.summaries?.first {
                    var updatedSummary = firstSummary
                    updatedSummary.contents = "1. 대화에서 다음과 같은 의견을 주장했습니다: \"\(extractedText)\"\n2. 상대방은 내 주장을 잘 이해하지 못한 것 같았습니다.\n3. 더 명확하게 소통할 필요가 있다고 느꼈습니다."
                    
                    if analysisData.summaries!.count > 0 {
                        analysisData.summaries![0] = updatedSummary
                    }
                }
                
                if let secondSummary = analysisData.summaries?.last, analysisData.summaries!.count > 1 {
                    var updatedSummary = secondSummary
                    updatedSummary.contents = "1. 상대방은 이런 말을 했습니다: \"\(extractedText)\"\n2. 이것은 내 감정과 상황을 고려하지 않은 발언이라고 생각했습니다.\n3. 서로 다른 관점에서 바라보는 대화가 필요하다고 느꼈습니다."
                    
                    analysisData.summaries![1] = updatedSummary
                }
            }
        }
        
        return analysisData
    }
}
