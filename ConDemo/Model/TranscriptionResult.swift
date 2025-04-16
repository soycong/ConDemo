//
//  TranscriptionResult.swift
//  ConDemo
//
//  Created by 이명지 on 4/15/25.
//

import Foundation

// MARK: - 데이터 모델 정의
struct TranscriptionResult: Codable {
    let jobName: String
    let accountId: String
    let status: String
    let results: Results
}

struct Results: Codable {
    let transcripts: [Transcript]
    let items: [Item]
    let audioSegments: [AudioSegment]?
    let speakerLabels: SpeakerLabels?
    
    enum CodingKeys: String, CodingKey {
        case transcripts, items
        case audioSegments = "audio_segments"
        case speakerLabels = "speaker_labels"
    }
}

struct Transcript: Codable {
    let transcript: String
}

struct Item: Codable {
    let id: Int
    let type: String
    let alternatives: [Alternative]
    let startTime: String?
    let endTime: String?
    let speakerLabel: String?
    
    enum CodingKeys: String, CodingKey {
        case id, type, alternatives
        case startTime = "start_time"
        case endTime = "end_time"
        case speakerLabel = "speaker_label"
    }
}

struct Alternative: Codable {
    let confidence: String
    let content: String
}

struct AudioSegment: Codable {
    let id: Int
    let transcript: String
    let startTime: String
    let endTime: String
    let speakerLabel: String?
    let items: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id, transcript, items
        case startTime = "start_time"
        case endTime = "end_time"
        case speakerLabel = "speaker_label"
    }
}

struct SpeakerLabels: Codable {
    let segments: [Segment]
    let channelLabel: String
    let speakers: Int
    
    enum CodingKeys: String, CodingKey {
        case segments
        case channelLabel = "channel_label"
        case speakers
    }
}

struct Segment: Codable {
    let startTime: String
    let endTime: String
    let speakerLabel: String
    let items: [SegmentItem]
    
    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
        case speakerLabel = "speaker_label"
        case items
    }
}

struct SegmentItem: Codable {
    let speakerLabel: String
    let startTime: String
    let endTime: String
    
    enum CodingKeys: String, CodingKey {
        case speakerLabel = "speaker_label"
        case startTime = "start_time"
        case endTime = "end_time"
    }
}

extension TranscriptionResult {
    func printTranscript() {
        if let transcript = results.transcripts.first?.transcript {
            print("\n[전체 스크립트]")
            transcript.components(separatedBy: ". ").forEach { print($0) }
        }
    }
    
    func printSpeakersTranscript() {
        guard let speakerLabels = results.speakerLabels else { return }
        
        print("\n[화자별 스크립트]")
        speakerLabels.segments.forEach { segment in
            let transcript = segment.items.map { item -> String in
                if let matchingItem = results.items.first(where: {
                    $0.startTime == item.startTime && $0.endTime == item.endTime
                }) {
                    return matchingItem.alternatives.first?.content ?? ""
                }
                return ""
            }.joined(separator: " ")
            
            print("화자 \(segment.speakerLabel.dropFirst(4))")
            print("- \(transcript)\n")
        }
    }
}
