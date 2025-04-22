//
//  RecordingMainViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/10/25.
//

import Foundation
import CoreData

protocol TranscriptionDelegate: AnyObject {
    func didReceiveTranscription(text: String)
}

final class RecordingMainViewModel {
    weak var transcriptionDelegate: TranscriptionDelegate?
    
    private(set) var isRecording = false
    var hasStartedRecordingOnce: Bool = false

    private let audioRecorder: AudioRecorder = .init()
    private let speechRecognizer: SpeechRecognizer = .init()
    
    private var isPlaying = false
    private var isPaused = false
}

extension RecordingMainViewModel {
    func startRecording() {
        audioRecorder.startRecording()
        isRecording = true
        print("녹음 시작")
        speechRecognizer.delegate = self.transcriptionDelegate
        speechRecognizer.startTranscribing()
    }

    func pauseRecording() {
        audioRecorder.pauseRecording()
        isRecording = false
        print("녹음 일시정지")
    }

    func restartRecording() {
        audioRecorder.restartRecording()
        isRecording = true
        print("녹음 재시작")
    }

    func stopRecording() -> URL {
        let resultPath = audioRecorder.stopRecording()
        isRecording = false
        hasStartedRecordingOnce = false
        print("녹음 종료")
        speechRecognizer.stopTranscribing()
        
        return resultPath
    }

    func recordToggle() {
        // 녹음중이 아니다 -> 녹음 재시작
        if !isRecording {
            restartRecording()
        }
        // 녹음중이다 -> 녹음 일시정지
        else {
            pauseRecording()
        }
    }
}

extension RecordingMainViewModel {
    func fetchAnalysisAvailableDates() -> [Date] {
        // CoreData에서 모든 Analysis 객체의 날짜 가져오기
        let fetchRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
        fetchRequest.propertiesToFetch = ["date"] // 날짜만 가져오기
        
        do {
            let analyses = try CoreDataManager.shared.context.fetch(fetchRequest)
            
            // nil이 아닌 날짜만 반환
            return analyses.compactMap { $0.date }
        } catch {
            print("분석 날짜 조회 실패: \(error)")
            return []
        }
    }
    
    func fetchAnalysisForDate(_ date: Date) -> Analysis? {
        let calendar = Calendar.current
        
        // 선택된 날짜의 시작과 끝 시간 계산
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // 해당 날짜 범위에 있는 Analysis 찾기
        let fetchRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let analyses = try CoreDataManager.shared.context.fetch(fetchRequest)
            return analyses.first
        } catch {
            print("분석 데이터 조회 실패: \(error)")
            return nil
        }
    }
}
