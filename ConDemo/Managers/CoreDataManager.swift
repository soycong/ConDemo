//
//  CoreDataManager.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//

import CoreData
import UIKit

final class CoreDataManager {
    // MARK: - Static Properties
    
    static let shared: CoreDataManager = .init()
    
    static var title = ""
    
    // MARK: - Computed Properties
    
    var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // MARK: - Lifecycle
    
    private init() { }
    
    // MARK: - Functions
    
    /// 새로운 분석 생성 및 메시지 저장
    func createAnalysis(messages: [MessageData]) -> Analysis {
        let analysis: Analysis = .init(context: context)
        analysis.title = "대화 분석 \(Date().timeIntervalSince1970.description)"
        analysis.contents = "대화 분석 내용\n\(Date().timeIntervalSince1970.description)"
        analysis.date = Date()
        analysis.level = Int32.random(in: 1 ... 9)
        
        // 각 메시지를 저장
        for messageData in messages {
            let message: Message = .init(context: context)
            message.id = messageData.id
            message.text = messageData.text
            message.isFromCurrentUser = messageData.isFromCurrentUser
            message.timestamp = messageData.timestamp
            message.image = messageData.image?.description
            message.audioURL = messageData.audioURL?.description
            message.audioData = messageData.audioData
            
            message.analysis = analysis
        }
        
        do {
            try context.save()
            print("코어 데이터 저장 완료\n")
        } catch {
            print("코어 데이터 저장 실패: \(error)")
        }
        
        return analysis
    }
    
    /// 특정 분석 결과의 메시지 가져오기
    func fetchMessages(from analysisTitle: String) -> [MessageData] {
        // 1. 해당 타이틀을 가진 Analysis 찾기
        let analysisRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
        analysisRequest.predicate = NSPredicate(format: "title == %@", analysisTitle)
        
        var messagesData: [MessageData] = .init()
        
        do {
            // 2. Analysis 객체 가져오기 (중복된 타이틀이 있을 수 있으므로 배열로 받음)
            let analyses = try context.fetch(analysisRequest)
            
            // 분석 결과가 없으면 빈 배열 반환
            guard let analysis = analyses.first else {
                print("해당 타이틀(\(analysisTitle))을 가진 분석 결과가 없습니다.")
                return []
            }
            
            // 3. 해당 Analysis에 연결된 메시지 찾기
            let messageRequest: NSFetchRequest<Message> = Message.fetchRequest()
            messageRequest.predicate = NSPredicate(format: "analysis == %@", analysis)
            messageRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
            
            // 4. 메시지 가져오기 및 MessageData로 변환
            let messages = try context.fetch(messageRequest)
            for message in messages {
                messagesData.append(message.toMessageData())
            }
            
            return messagesData
        } catch {
            print("메시지 조회 실패: \(error)")
            return []
        }
    }
    
    /// 모든 분석 결과 가져오기
    func fetchAllAnalyses() -> [Analysis] {
        let fetchRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("분석 데이터 조회 실패: \(error)")
            return []
        }
    }
    
    /// 날짜로 분석 결과 필터링하여 가져오기
    func fetchAnalyses(for date: Date) -> [Analysis] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let fetchRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("분석 데이터 조회 실패: \(error)")
            return []
        }
    }
    
    /// 특정 분석 결과 삭제하기
    func deleteAnalysis(_ analysis: Analysis) {
        context.delete(analysis)
        
        do {
            try context.save()
            print("분석 데이터 삭제 완료")
        } catch {
            print("분석 데이터 삭제 실패: \(error)")
        }
    }
}

extension CoreDataManager {
    // 테스트 데이터 생성 함수
    func createTestData(count: Int = 5) -> [Analysis] {
        var createdAnalyses: [Analysis] = []
        
        for i in 1...count {
            let analysis = Analysis(context: context)
            analysis.title = "테스트 분석 \(i)"
            analysis.contents = "테스트 내용 \(i)"
            analysis.date = Date().addingTimeInterval(-Double(i) * 24 * 3600) // i일 전
            analysis.level = Int32.random(in: 1...9)
            
            // 테스트 메시지 추가
            let message = Message(context: context)
            message.id = UUID().uuidString
            message.text = "테스트 메시지 \(i)"
            message.isFromCurrentUser = i % 2 == 0
            message.timestamp = analysis.date
            message.analysis = analysis
            
            createdAnalyses.append(analysis)
        }
        
        do {
            try context.save()
            print("테스트 데이터 \(count)개 생성 완료")
        } catch {
            print("테스트 데이터 생성 실패: \(error)")
        }
        
        return createdAnalyses
    }
    
    // 모든 데이터 삭제 함수
    func deleteAllData() {
        let entities = ["Analysis", "Message", "Log", "Poll", "Summary"]
        
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.persistentStoreCoordinator?.execute(deleteRequest, with: context)
            } catch {
                print("\(entity) 데이터 삭제 실패: \(error)")
            }
        }
        
        do {
            try context.save()
            print("모든 데이터 삭제 완료")
        } catch {
            print("컨텍스트 저장 실패: \(error)")
        }
    }
    
    // 데이터 출력 함수
    func printAllAnalyses() {
        let fetchRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
        
        do {
            let analyses = try context.fetch(fetchRequest)
            print("=== 저장된 Analysis 목록 (총 \(analyses.count)개) ===")
            
            for (i, analysis) in analyses.enumerated() {
                let dateStr = analysis.date?.formatted(date: .numeric, time: .shortened) ?? "날짜 없음"
                print("#\(i+1) 제목: \(analysis.title ?? "제목 없음") | 날짜: \(dateStr) | 레벨: \(analysis.level)")
            }
            
            print("=====================================")
        } catch {
            print("데이터 조회 실패: \(error)")
        }
    }
}

extension CoreDataManager {
    func saveAnalysis(data: AnalysisData) {
        // 1. 아날리시스부터 저장
        let analysis = Analysis(context: context)
        analysis.title = data.title.replacingOccurrences(of: "\"", with: "")
        analysis.date = data.date
        analysis.contents = data.contents.replacingOccurrences(of: "\"", with: "")
        analysis.level = Int32(data.level)
        
        // 2. 메세지 Object 생성, 아날리시스에도 저장
        if let messages = data.messages {
            for messageData in messages {
                let message = Message(context: context)
                message.id = messageData.id
                message.text = messageData.text.replacingOccurrences(of: "\"", with: "")
                message.isFromCurrentUser = messageData.isFromCurrentUser
                message.timestamp = messageData.timestamp
                message.image = messageData.image?.description
                message.audioURL = messageData.audioURL?.description
                message.audioData = messageData.audioData
                
                message.analysis = analysis
            }
        }
        
        // 3. poll - 배열로 처리
        if let polls = data.polls, !polls.isEmpty {
            // 모든 Poll 객체 생성
            for pollData in polls {
                let poll = Poll(context: context)
                poll.date = pollData.date
                poll.title = pollData.title.replacingOccurrences(of: "\"", with: "")
                poll.contents = pollData.contents.replacingOccurrences(of: "\"", with: "")
                poll.hers = pollData.yourOpinion.replacingOccurrences(of: "\"", with: "")
                poll.his = pollData.myOpinion.replacingOccurrences(of: "\"", with: "")
                
                // [String]을 NSObject로 변환
                let cleanOptions = pollData.options.map { $0.replacingOccurrences(of: "\"", with: "") }
                
                do {
                    let optionsData = try JSONSerialization.data(withJSONObject: cleanOptions)
                    poll.option = optionsData as NSObject
                } catch {
                    print("옵션 NSObject 변환 오류: \(error)")
                    print("옵션에 빈 배열 저장")
                    poll.option = "[]" as NSObject
                }
                
                // 관계 설정
                poll.analysis = analysis
            }
        }
        
        // 4. Summary
        if let summaryData = data.summaries?[0] {
            let summary = Summary(context: context)
            summary.title = summaryData.title.replacingOccurrences(of: "\"", with: "")
            summary.contents = summaryData.contents.replacingOccurrences(of: "\"", with: "")
            summary.date = summaryData.date
            
            // 관계 설정
            summary.analysis = analysis
        }
        
        // DetailedTranscriptAnalysis 저장 코드 추가
        if let detailedData = data.detailedTranscriptAnalysisData {
            let detailedAnalysis = DetailedTranscriptAnalysis(context: context)
            
            // 1. SpeakingTime 저장
            let speakingTime = SpeakingTime(context: context)
            speakingTime.speakerA = detailedData.speakingTime.speakerA
            speakingTime.speakerB = detailedData.speakingTime.speakerB
            detailedAnalysis.speakingTime = speakingTime
            
            // 2. Overlaps 저장
            let overlaps = Overlaps(context: context)
            overlaps.count = Int64(detailedData.overlaps.count)
            overlaps.totalDuration = detailedData.overlaps.totalDuration
            detailedAnalysis.overlaps = overlaps
            
            // 3. overlapTopics 저장 ([String] -> NSObject)
            do {
                let topicsData = try JSONSerialization.data(withJSONObject: detailedData.overlapTopics)
                detailedAnalysis.overlapTopics = topicsData as NSObject
            } catch {
                print("overlapTopics 변환 오류: \(error)")
                detailedAnalysis.overlapTopics = "[]" as NSObject
            }
            
            // 4. Consistency 저장
            let consistency = Consistency(context: context)
            
            // SpeakerA
            let consistencySpeakerA = SpeakerEvaluation(context: context)
            consistencySpeakerA.score = Int64(detailedData.consistency.speakerA.score)
            consistencySpeakerA.reasoning = detailedData.consistency.speakerA.reasoning.replacingOccurrences(of: "\"", with: "")
            
            // SpeakerB
            let consistencySpeakerB = SpeakerEvaluation(context: context)
            consistencySpeakerB.score = Int64(detailedData.consistency.speakerB.score)
            consistencySpeakerB.reasoning = detailedData.consistency.speakerB.reasoning.replacingOccurrences(of: "\"", with: "")
            
            consistency.speakerA = consistencySpeakerA
            consistency.speakerB = consistencySpeakerB
            detailedAnalysis.consistency = consistency
            
            // 5. FactualAccuracy 저장
            let factualAccuracy = FactualAccuracy(context: context)
            
            // SpeakerA
            let factualSpeakerA = SpeakerEvaluation(context: context)
            factualSpeakerA.score = Int64(detailedData.factualAccuracy.speakerA.score)
            factualSpeakerA.reasoning = detailedData.factualAccuracy.speakerA.reasoning.replacingOccurrences(of: "\"", with: "")
            
            // SpeakerB
            let factualSpeakerB = SpeakerEvaluation(context: context)
            factualSpeakerB.score = Int64(detailedData.factualAccuracy.speakerB.score)
            factualSpeakerB.reasoning = detailedData.factualAccuracy.speakerB.reasoning.replacingOccurrences(of: "\"", with: "")
            
            factualAccuracy.speakerA = factualSpeakerA
            factualAccuracy.speakerB = factualSpeakerB
            detailedAnalysis.factualAccuracy = factualAccuracy
            
            // 6. SentimentAnalysis 저장
            let sentimentAnalysis = SentimentAnalysis(context: context)
            
            // SpeakerA
            let sentimentSpeakerA = SentimentExamples(context: context)
            sentimentSpeakerA.positiveRatio = detailedData.sentimentAnalysis.speakerA.positiveRatio
            sentimentSpeakerA.negativeRatio = detailedData.sentimentAnalysis.speakerA.negativeRatio
            
            // 예제 문장 저장 ([String] -> NSObject)
            do {
                let positiveExamplesData = try JSONSerialization.data(withJSONObject: detailedData.sentimentAnalysis.speakerA.positiveExamples)
                sentimentSpeakerA.positiveExamples = positiveExamplesData as NSObject
                
                let negativeExamplesData = try JSONSerialization.data(withJSONObject: detailedData.sentimentAnalysis.speakerA.negativeExamples)
                sentimentSpeakerA.negativeExamples = negativeExamplesData as NSObject
            } catch {
                print("sentiment examples 변환 오류: \(error)")
                sentimentSpeakerA.positiveExamples = "[]" as NSObject
                sentimentSpeakerA.negativeExamples = "[]" as NSObject
            }
            
            // SpeakerB - 위와 동일한 방식
            let sentimentSpeakerB = SentimentExamples(context: context)
            sentimentSpeakerB.positiveRatio = detailedData.sentimentAnalysis.speakerB.positiveRatio
            sentimentSpeakerB.negativeRatio = detailedData.sentimentAnalysis.speakerB.negativeRatio
            
            do {
                let positiveExamplesData = try JSONSerialization.data(withJSONObject: detailedData.sentimentAnalysis.speakerB.positiveExamples)
                sentimentSpeakerB.positiveExamples = positiveExamplesData as NSObject
                
                let negativeExamplesData = try JSONSerialization.data(withJSONObject: detailedData.sentimentAnalysis.speakerB.negativeExamples)
                sentimentSpeakerB.negativeExamples = negativeExamplesData as NSObject
            } catch {
                print("sentiment examples 변환 오류: \(error)")
                sentimentSpeakerB.positiveExamples = "[]" as NSObject
                sentimentSpeakerB.negativeExamples = "[]" as NSObject
            }
            
            sentimentAnalysis.speakerA = sentimentSpeakerA
            sentimentAnalysis.speakerB = sentimentSpeakerB
            detailedAnalysis.sentimentAnalysis = sentimentAnalysis
            
            // 7. IncorrectUsage 저장
            let incorrectUsage = IncorrectUsage(context: context)
            
            // SpeakerA
            let incorrectSpeakerA = IncorrectUsageExamples(context: context)
            incorrectSpeakerA.count = Int64(detailedData.incorrectUsage.speakerA.count)
            
            do {
                let examplesData = try JSONSerialization.data(withJSONObject: detailedData.incorrectUsage.speakerA.examples)
                incorrectSpeakerA.examples = examplesData as NSObject
            } catch {
                print("incorrect examples 변환 오류: \(error)")
                incorrectSpeakerA.examples = "[]" as NSObject
            }
            
            // SpeakerB
            let incorrectSpeakerB = IncorrectUsageExamples(context: context)
            incorrectSpeakerB.count = Int64(detailedData.incorrectUsage.speakerB.count)
            
            do {
                let examplesData = try JSONSerialization.data(withJSONObject: detailedData.incorrectUsage.speakerB.examples)
                incorrectSpeakerB.examples = examplesData as NSObject
            } catch {
                print("incorrect examples 변환 오류: \(error)")
                incorrectSpeakerB.examples = "[]" as NSObject
            }
            
            incorrectUsage.speakerA = incorrectSpeakerA
            incorrectUsage.speakerB = incorrectSpeakerB
            detailedAnalysis.incorrectUsage = incorrectUsage
            
            // 8. 날짜 설정
            detailedAnalysis.date = detailedData.date
            
            // 9. Analysis와 연결
            detailedAnalysis.analysis = analysis
        }
        
        // 10. 저장
        do {
            try context.save()
            // print("DetailedAnalysis: \(String(describing: data.detailedTranscriptAnalysisData))")
            // 11. 정적 타이틀 업데이트
            Self.title = analysis.title ?? ""
        } catch {
            print("코어 데이터 저장 실패: \(error)")
        }
    }
}
