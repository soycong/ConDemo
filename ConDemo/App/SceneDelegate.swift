//
//  SceneDelegate.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Functions

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession,
               options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let window: UIWindow = .init(windowScene: windowScene)
        window.rootViewController = LaunchViewController()
        window.makeKeyAndVisible()
        self.window = window

        /// AWS 테스트용 코드(추후 삭제)
        Task {
            let args: Array = .init(CommandLine.arguments.dropFirst())

            do {
                let command = try Transcriber.parse(args)
                print("시작\n")
                try await command.transcribe(encoding: command.getMediaEncoding())
                print("\n완료")
            } catch let error as TranscribeError {
                print("트랜스크립션 오류: \(error.errorDescription ?? "알 수 없는 오류")")
            } catch {
                print("일반 오류: \(error)")
                Transcriber.exit(withError: error)
            }
        }
    }

    func sceneDidEnterBackground(_: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

enum TranscribeError: Error {
    /// No transcription stream available.
    case noTranscriptionStream
    /// The source media file couldn't be read.
    case readError

    // MARK: - Computed Properties

    var errorDescription: String? {
        switch self {
        case .noTranscriptionStream:
            "No transcription stream returned by Amazon Transcribe."
        case .readError:
            "Unable to read the source audio file."
        }
    }
}
