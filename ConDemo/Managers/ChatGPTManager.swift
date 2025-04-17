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

    func analyzeTranscript(messages: [MessageData],
                           completion: @escaping (Result<String, Error>) -> Void) async {
        let transcript = messages.map {
            "\($0.isFromCurrentUser ? "나" : "상대방"): \($0.text)"
        }.joined(separator: "\n")

        await requestAnalysis(transcript: transcript) { result in
            switch result {
            case let .success(response):
                do {
//                    let analysis = try self.saveAnalysis(messages: messages, response: response)
                    completion(.success(response.choices.first!.message.content))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func requestAnalysis(transcript: String,
                                 completion: @escaping (Result<ChatGPTResponse, Error>) -> Void) {
        let text = """
                다음은 두 사람 간의 대화 내용입니다:

                \(transcript)

                이 대화를 분석하여 다음 정보를 제공해주세요:

                1. 대화를 요약하는 제목과 주요 쟁점 3가지를 추출해주세요. 재밌고 매력적이게 추출해주세요.

                2. 3개 쟁점 각각에 대한 poll을 생성해주세요. 각 poll은 다음 형식을 따라야 합니다:
                   - 쟁점 제목: [제목]
                   - 내용: [내용 설명]
                   - 나의 의견: [첫 번째 화자의 의견]
                   - 상대방 의견: [두 번째 화자의 의견]
                   - 옵션: [투표 옵션들, 쉼표로 구분, 총 4개]

                3. 커뮤니티에 게시글로 올라갈 요약본을 작성해주세요. 다음 형식을 따라야 합니다:
                   - 제목: [대화 주제를 반영한 간결하고 매력적인 제목]
                   - 내용: [대화의 핵심 내용과 결론을 포함한 300자 이내의 요약]

                각 섹션을 명확히 구분해서 응답해주세요.
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

        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default,
                   headers: headers)
            .validate()
            .responseDecodable(of: ChatGPTResponse.self) { response in
                switch response.result {
                case let .success(chatGPTResponse):
                    completion(.success(chatGPTResponse))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }

//    private func saveAnalysis(messages: [MessageData], response: ChatGPTResponse) throws ->
//    Analysis {
//        guard let content = response.choices.first?.message.content else {
//            throw NSError(domain: String(describing: ChatGPTManager.self), code: 1, userInfo:
//            [NSLocalizedDescriptionKey: "ChatGPT 응답 내용이 없습니다"])
//        }
//
//        let parsedData = try parseResponse(content)
//
//        let context = CoreDataManager.shared.context
//
//        // 1. 아날리시스부터 저장
//        let analysis = Analysis(context: context)
//        analysis.title = parsedData.title
//        analysis.date = parsedData.date
//        analysis.contents = parsedData.contents
//        analysis.level = Int32(parsedData.level)
//
//        // 2. 메세지 Object 생성, 아날리시스에도 저장
//        messages.forEach { messageData in
//            let message = Message(context: context)
//            message.id = messageData.id
//            message.text = messageData.text
//            message.isFromCurrentUser = messageData.isFromCurrentUser
//            message.timestamp = messageData.timestamp
//            message.image = messageData.image?.description
//            message.audioURL = messageData.audioURL?.description
//            message.audioData = messageData.audioData
//
//            message.analysis = analysis
//        }
//
//        // 3. poll
//        parsedData.polls.forEach { pollData in
//            let poll = Poll(context: context)
//            poll.date = pollData.date
//            poll.title = pollData.title
//            poll.contents = pollData.contents
//            poll.hers = pollData.hers
//            poll.his = pollData.his
//
//            // [String]을 NSObject로 변환
//            do {
//                let optionsData = try JSONSerialization.data(withJSONObject: pollData.options)
//                poll.option = optionsData as NSObject
//            } catch {
//                print("옵션 NSObject 변환 오류: \(error)")
//                print("옵션에 빈 배열 저장")
//                poll.option = "[]" as NSObject
//            }
//        }
//
//        // 4. Summary
//        let summary = Summary(context: context)
//        summary.title
//    }
//
//    private func parseResponse(_ response: String) throws -> AnalysisData {
//
//    }
}
