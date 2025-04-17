//
//  TranscriptionResult.swift
//  ConDemo
//
//  Created by 이명지 on 4/15/25.
//

import Foundation

// MARK: - 데이터 모델 정의

struct TranscriptionResponse: Codable {
    let jobName: String
    let accountId: String
    let status: String
    let results: Results
}

struct Results: Codable {
    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case transcripts
        case items
        case audioSegments = "audio_segments"
        case speakerLabels = "speaker_labels"
    }

    // MARK: - Properties

    let transcripts: [Transcript]
    let items: [Item]
    let audioSegments: [AudioSegment]?
    let speakerLabels: SpeakerLabels?
}

struct Transcript: Codable {
    let transcript: String
}

struct Item: Codable {
    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case alternatives
        case startTime = "start_time"
        case endTime = "end_time"
        case speakerLabel = "speaker_label"
    }

    // MARK: - Properties

    let id: Int
    let type: String
    let alternatives: [Alternative]
    let startTime: String?
    let endTime: String?
    let speakerLabel: String?
}

struct Alternative: Codable {
    let confidence: String
    let content: String
}

struct AudioSegment: Codable {
    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case id
        case transcript
        case items
        case startTime = "start_time"
        case endTime = "end_time"
        case speakerLabel = "speaker_label"
    }

    // MARK: - Properties

    let id: Int
    let transcript: String
    let startTime: String
    let endTime: String
    let speakerLabel: String?
    let items: [Int]
}

struct SpeakerLabels: Codable {
    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case segments
        case channelLabel = "channel_label"
        case speakers
    }

    // MARK: - Properties

    let segments: [Segment]
    let channelLabel: String
    let speakers: Int
}

struct Segment: Codable {
    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
        case speakerLabel = "speaker_label"
        case items
    }

    // MARK: - Properties

    let startTime: String
    let endTime: String
    let speakerLabel: String
    let items: [SegmentItem]
}

struct SegmentItem: Codable {
    // MARK: - Nested Types

    enum CodingKeys: String, CodingKey {
        case speakerLabel = "speaker_label"
        case startTime = "start_time"
        case endTime = "end_time"
    }

    // MARK: - Properties

    let speakerLabel: String
    let startTime: String
    let endTime: String
}

extension TranscriptionResponse {
    func printTranscript() {
        if let transcript = results.transcripts.first?.transcript {
            print("\n[전체 스크립트]")
            transcript.components(separatedBy: ". ").forEach { print($0) }
        }
    }

    func getTranscript() -> [MessageData] {
        guard let speakerLabels = results.speakerLabels else {
            return []
        }
        
        var messages = [MessageData]()
        for segment in speakerLabels.segments {
            let transcript = segment.items.map { item -> String in
                if let matchingItem = results.items.first(where: {
                    $0.startTime == item.startTime && $0.endTime == item.endTime
                }) {
                    return matchingItem.alternatives.first?.content ?? ""
                }
                return ""
            }.joined(separator: " ")

            let isFromCurrentUser = segment.speakerLabel.dropFirst(4) == "0" ? true : false
            messages.append(MessageData(text: transcript, isFromCurrentUser: isFromCurrentUser))
            
            print("화자 \(segment.speakerLabel.dropFirst(4))")
            print("- \(transcript)\n")
        }
        
        return messages
    }
}
