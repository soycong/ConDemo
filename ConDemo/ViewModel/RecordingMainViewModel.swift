//
//  RecordingMainViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/10/25.
//

import Foundation
import CoreData

protocol TranscriptionDelegate: AnyObject {
    func didReceiveTranscription(text: String, speaker: String)
}

final class RecordingMainViewModel {
    weak var transcriptionDelegate: TranscriptionDelegate?
    
    private(set) var isRecording = false
    var hasStartedRecordingOnce: Bool = false

    private let audioRecorder: AudioRecorder = .init()
    private var streamingTranscriber: StreamingTranscriber?
    
    private var isPlaying = false
    private var isPaused = false
    
    // 10초 간격 타이머
    private var segmentTimer: Timer?
    private var currentSegmentPath: String?
    private var lastProcessedByteOffset: Int = 0

    deinit {
        stopSegmentTimer()
    }
}

extension RecordingMainViewModel {
    func startRecording() {
        audioRecorder.startRecording()
        isRecording = true
        print("녹음 시작")
        
        // 녹음 시작과 함께 세그먼트 타이머 시작
        startSegmentTimer()
    }

    func pauseRecording() {
        audioRecorder.pauseRecording()
        isRecording = false
        print("녹음 일시정지")
        
        // 녹음 일시정지 시 타이머도 일시정지
        stopSegmentTimer()
    }

    func restartRecording() {
        audioRecorder.restartRecording()
        isRecording = true
        print("녹음 재시작")
        
        // 녹음 재시작 시 타이머도 재시작
        startSegmentTimer()
    }

    func stopRecording() -> URL {
        let resultPath = audioRecorder.stopRecording()
        isRecording = false
        hasStartedRecordingOnce = false
        print("녹음 종료")
        
        // 녹음 종료 시 타이머 종료
        stopSegmentTimer()
        
        // 마지막 세그먼트 처리
        processCurrentSegment()
        
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
    private func startSegmentTimer() {
        stopSegmentTimer() // 기존 타이머가 있다면 중지
        
        // 10초마다 실행되는 타이머 설정
        segmentTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.processCurrentSegment()
        }
    }
    
    private func stopSegmentTimer() {
        segmentTimer?.invalidate()
        segmentTimer = nil
    }
    
    private func processCurrentSegment() {
        guard let audioFilePath = audioRecorder.getCurrentAudioSegment() else { return }
        
        // 파일 크기 확인
        let fileURL = URL(fileURLWithPath: audioFilePath)
        let fileSize = try? FileManager.default.attributesOfItem(atPath: audioFilePath)[.size] as? Int ?? 0
        
        // 새로 추가된 부분만 추출해서 임시 파일로 저장
        Task {
            if let fileSize = fileSize, fileSize > lastProcessedByteOffset {
                do {
                    let tempFile = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".flac")
                    
                    // 파일의 새 부분만 추출
                    let fileHandle = try FileHandle(forReadingFrom: fileURL)
                    try fileHandle.seek(toOffset: UInt64(lastProcessedByteOffset))
                    let newData = fileHandle.readData(ofLength: fileSize - lastProcessedByteOffset)
                    fileHandle.closeFile()
                    
                    // 임시 파일에 저장
                    try newData.write(to: tempFile)
                    
                    // 트랜스크라이버로 처리
                    streamingTranscriber = try StreamingTranscriber.parse([
                        "--format", "flac",
                        "--path", tempFile.path,
                        "--show-partial", "false"
                    ])
                    
                    guard let streamingTranscriber = streamingTranscriber else {
                        print("streamingTranscriber가 nil입니다")
                        return
                    }
                    
                    // 트랜스크립션 처리
                    for await (text, speaker, startTime, endTime) in streamingTranscriber.transcribeWithMessageStream(encoding: streamingTranscriber.getMediaEncoding()) {
                        await MainActor.run {
                            self.transcriptionDelegate?.didReceiveTranscription(text: text, speaker: speaker)
                        }
                    }
                    
                    // 처리 후 오프셋 업데이트
                    lastProcessedByteOffset = fileSize
                    
                    // 임시 파일 삭제
                    try FileManager.default.removeItem(at: tempFile)
                } catch {
                    print("청크 처리 오류: \(error)")
                }
            }
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
    
    //    func fetchAnalysisForDate(_ date: Date) -> Analysis? {
    //        let calendar = Calendar.current
    //
    //        // 선택된 날짜의 시작과 끝 시간 계산
    //        let startOfDay = calendar.startOfDay(for: date)
    //        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
    //
    //        // 해당 날짜 범위에 있는 Analysis 찾기
    //        let fetchRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
    //        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
    //        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    //
    //        do {
    //            let analyses = try CoreDataManager.shared.context.fetch(fetchRequest)
    //            return analyses.first
    //        } catch {
    //            print("분석 데이터 조회 실패: \(error)")
    //            return nil
    //        }
    //    }
    
    // 특정 날짜의 모든 분석 데이터 가져오기
    func fetchAllAnalysesForDate(_ date: Date) -> [Analysis] {
        let calendar = Calendar.current
        
        // 선택된 날짜의 시작과 끝 시간 계산
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // 해당 날짜 범위에 있는 모든 Analysis 찾기
        let fetchRequest: NSFetchRequest<Analysis> = Analysis.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let analyses = try CoreDataManager.shared.context.fetch(fetchRequest)
            return analyses
        } catch {
            print("분석 데이터 조회 실패: \(error)")
            return []
        }
    }
}
