//
//  Transcriber.swift
//  ConDemo
//
//  Created by 이명지 on 4/14/25.
//

import ArgumentParser
import AWSClientRuntime
import AWSTranscribeStreaming
import CoreFoundation
import Foundation

struct Transcriber: ParsableCommand {
    // MARK: - Nested Types

    /// input 파일 형식
    enum TranscribeFormat: String, ExpressibleByArgument {
        case ogg = "ogg"
        case pcm = "pcm"
        case flac = "flac"
    }

    private enum TranscribeError: Error {
        case noTranscriptionStream
        case readError

        // MARK: - Computed Properties

        var errorDescription: String? {
            switch self {
            case .noTranscriptionStream:
                "AWS에서 트랜스크립션 스트림 반환하지 않았음."
            case .readError:
                "입력 파일 읽기 오류"
            }
        }
    }

    // MARK: - Static Properties

    static var configuration: CommandConfiguration = .init(commandName: "tsevents",
                                                           abstract: """
                                                           This example shows how to use event streaming with Amazon Transcribe.
                                                           """,
                                                           discussion: """
                                                           """)

    // MARK: - Properties

    /// 부분 결과 true -> 실시간 출력 O, 화자 분리 X
    /// 부분 결과 false -> 실시간 출력 X, 화자 분리 O
    @Option(help: "Show partial results")
    var showPartial = true
    @Option(help: "Language code to transcribe into")
    var lang: String = "ko-KR"
    @Option(help: "Format of the source audio file")
    var format: TranscribeFormat
    @Option(help: "Sample rate of the source audio file in Hertz")
    var sampleRate: Int = 48000
    @Option(help: "Path of the source audio file")
    var path: String
    @Option(help: "Name of the Amazon S3 Region to use(default: ap-northeast-2)")
    var region: String = "ap-northeast-2"

    // MARK: - Functions

    func createAudioStream() async throws
        -> AsyncThrowingStream<TranscribeStreamingClientTypes.AudioStream, Error> {
        guard let fileURL = Bundle.main.url(forResource: "testAudio", withExtension: "flac") else {
            print("프로젝트 내부에서 파일을 찾을 수 없습니다")
            throw TranscribeError.readError
        }
        let audioData = try Data(contentsOf: fileURL)

        let chunkSizeInMilliseconds = 125.0
        let chunkSize: Int = .init(chunkSizeInMilliseconds / 1000.0 * Double(sampleRate) * 2.0)
        let audioDataSize = audioData.count

        return AsyncThrowingStream<TranscribeStreamingClientTypes.AudioStream,
            Error> { continuation in
            Task {
                var currentStart = 0
                var currentEnd = min(chunkSize, audioDataSize - currentStart)

                while currentStart < audioDataSize {
                    let dataChunk = audioData[currentStart ..< currentEnd]

                    let audioEvent = TranscribeStreamingClientTypes.AudioStream
                        .audioevent(.init(audioChunk: dataChunk))
                    let yieldResult = continuation.yield(audioEvent)

                    switch yieldResult {
                    case .enqueued:
                        break
                    case .dropped:
                        print("Warning: Dropped audio! The transcription will be incomplete.")
                    case .terminated:
                        print("Audio stream terminated.")
                        continuation.finish()
                        return
                    default:
                        print("Warning: Unrecognized response during audio streaming.")
                    }

                    currentStart = currentEnd
                    currentEnd = min(currentStart + chunkSize, audioDataSize)
                }

                continuation.finish()
            }
        }
    }

    /// 메세지 전달 메서드
    func transcribeWithMessageStream(encoding: TranscribeStreamingClientTypes
        .MediaEncoding) -> AsyncStream<(text: String,
                                        speaker: String)> {
        AsyncStream<(text: String, speaker: String)> { continuation in
            Task {
                let totalStartTime = CFAbsoluteTimeGetCurrent()

                guard let accessKey = Bundle.main.infoDictionary?["AWS_ACCESS_KEY_ID"] as? String,
                      let secretKey = Bundle.main
                      .infoDictionary?["AWS_SECRET_ACCESS_KEY"] as? String else {
                    print("Info.plist에서 AWS 인증 정보를 찾을 수 없습니다.")
                    continuation.finish()
                    return
                }

                // AWS 서버 지역 설정
                do {
                    let clientConfig = try await TranscribeStreamingClient
                        .TranscribeStreamingClientConfiguration(region: region)

                    // 환경 변수 설정
                    setenv("AWS_ACCESS_KEY_ID", accessKey, 1)
                    setenv("AWS_SECRET_ACCESS_KEY", secretKey, 1)

                    let client: TranscribeStreamingClient = .init(config: clientConfig)

                    let output = try await client
                        .startStreamTranscription(input: StartStreamTranscriptionInput(audioStream: createAudioStream(),
                                                                                       enablePartialResultsStabilization: true,
                                                                                       languageCode: TranscribeStreamingClientTypes
                                                                                           .LanguageCode(rawValue: lang),
                                                                                       mediaEncoding: encoding,
                                                                                       mediaSampleRateHertz: sampleRate,
                                                                                       partialResultsStability: .high,
                                                                                       showSpeakerLabel: true))

                    guard let transcriptResultStream = output.transcriptResultStream else {
                        print("No transcription stream returned")
                        continuation.finish()
                        return
                    }

                    for try await event in transcriptResultStream {
                        switch event {
                        case let .transcriptevent(event):
                            for result in event.transcript?.results ?? [] {
                                if !result.isPartial || showPartial {
                                    if let alternatives = result.alternatives,
                                       let firstAlternative = alternatives.first {
                                        if let items = firstAlternative.items, !items.isEmpty {
                                            var currentSpeaker = ""
                                            var currentText: [String] = []

                                            for item in items {
                                                let speaker = item.speaker ?? "0"
                                                let content = item.content ?? ""

                                                if currentSpeaker.isEmpty {
                                                    currentSpeaker = speaker
                                                } else if speaker != currentSpeaker &&
                                                    !currentText.isEmpty {
                                                    var utterance = currentText
                                                        .joined(separator: " ")

                                                    // 문장 앞에 ". "가 오는 경우 삭제
                                                    if utterance.hasPrefix(". ") {
                                                        utterance = utterance.dropFirst(2)
                                                            .trimmingCharacters(in: .whitespaces)
                                                    }

                                                    // "."만 있는 경우 제외하고 출력
                                                    if utterance
                                                        .trimmingCharacters(in: .whitespaces) !=
                                                        "." {
                                                        continuation.yield((text: utterance,
                                                                            speaker: currentSpeaker))
                                                    }

                                                    currentText = []
                                                    currentSpeaker = speaker
                                                }

                                                currentText.append(content)
                                            }

                                            if !currentText.isEmpty {
                                                var utterance = currentText.joined(separator: " ")

                                                if utterance.hasPrefix(". ") {
                                                    utterance = utterance.dropFirst(2)
                                                        .trimmingCharacters(in: .whitespaces)
                                                }

                                                if utterance
                                                    .trimmingCharacters(in: .whitespaces) != "." {
                                                    continuation.yield((text: utterance,
                                                                        speaker: currentSpeaker))
                                                    print("화자 \(currentSpeaker): \(utterance)")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        default:
                            print("Error: Unexpected message from Amazon Transcribe:")
                        }
                    }

                    let totalEndTime = CFAbsoluteTimeGetCurrent()
                    let executionTime = totalEndTime - totalStartTime

                    print("\n**총 실행 시간: \(String(format: "%.2f", executionTime))초**")
                    continuation.finish()
                } catch {
                    print("Transcription error: \(error)")
                    continuation.finish()
                }
            }
        }
    }

    func transcribe(encoding: TranscribeStreamingClientTypes.MediaEncoding) async throws {
        let totalStartTime = CFAbsoluteTimeGetCurrent()

        guard let accessKey = Bundle.main.infoDictionary?["AWS_ACCESS_KEY_ID"] as? String,
              let secretKey = Bundle.main.infoDictionary?["AWS_SECRET_ACCESS_KEY"] as? String else {
            print("Info.plist에서 AWS 인증 정보를 찾을 수 없습니다.")
            throw NSError(domain: "AWSCredentialsError", code: 1, userInfo: nil)
        }

        // AWS 서버 지역 설정
        let clientConfig = try await TranscribeStreamingClient
            .TranscribeStreamingClientConfiguration(region: region)

        // 환경 변수 설정
        setenv("AWS_ACCESS_KEY_ID", accessKey, 1)
        setenv("AWS_SECRET_ACCESS_KEY", secretKey, 1)

        let client: TranscribeStreamingClient = .init(config: clientConfig)

        let output = try await client
            .startStreamTranscription(input: StartStreamTranscriptionInput(audioStream: createAudioStream(),
                                                                           enablePartialResultsStabilization: true,
                                                                           languageCode: TranscribeStreamingClientTypes
                                                                               .LanguageCode(rawValue: lang),
                                                                           mediaEncoding: encoding,
                                                                           mediaSampleRateHertz: sampleRate,
                                                                           partialResultsStability: .high,
                                                                           showSpeakerLabel: true))

        for try await event in output.transcriptResultStream! {
            switch event {
            case let .transcriptevent(event):
                for result in event.transcript?.results ?? [] {
                    if !result.isPartial || showPartial {
                        if let alternatives = result.alternatives,
                           let firstAlternative = alternatives.first {
                            if let items = firstAlternative.items, !items.isEmpty {
                                var currentSpeaker = ""
                                var currentText: [String] = []

                                for item in items {
                                    let speaker = item.speaker ?? "0"
                                    let content = item.content ?? ""

                                    if currentSpeaker.isEmpty {
                                        currentSpeaker = speaker
                                    } else if speaker != currentSpeaker && !currentText.isEmpty {
                                        var utterance = currentText.joined(separator: " ")

                                        // 문장 앞에 ". "가 오는 경우 삭제
                                        if utterance.hasPrefix(". ") {
                                            utterance = utterance.dropFirst(2)
                                                .trimmingCharacters(in: .whitespaces)
                                        }

                                        // "."만 있는 경우 제외하고 출력
                                        if utterance.trimmingCharacters(in: .whitespaces) != "." {
                                            print("화자 \(currentSpeaker): \(utterance)")
                                        }

                                        currentText = []
                                        currentSpeaker = speaker
                                    }

                                    currentText.append(content)
                                }

                                if !currentText.isEmpty {
                                    var utterance = currentText.joined(separator: " ")

                                    if utterance.hasPrefix(". ") {
                                        utterance = utterance.dropFirst(2)
                                            .trimmingCharacters(in: .whitespaces)
                                    }

                                    if utterance.trimmingCharacters(in: .whitespaces) != "." {
                                        print("화자 \(currentSpeaker): \(utterance)")
                                    }
                                }
                            }
                        }
                    }
                }
            default:
                print("Error: Unexpected message from Amazon Transcribe:")
            }
        }

        let totalEndTime = CFAbsoluteTimeGetCurrent()
        let executionTime = totalEndTime - totalStartTime

        print("\n**총 실행 시간: \(String(format: "%.2f", executionTime))초**")
    }

    func getMediaEncoding() -> TranscribeStreamingClientTypes.MediaEncoding {
        switch format {
        case .ogg:
            .oggOpus
        case .pcm:
            .pcm
        case .flac:
            .flac
        }
    }
}
