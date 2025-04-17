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
}
