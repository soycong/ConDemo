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
