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
    }

    func sceneDidEnterBackground(_: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

enum StreamingTranscribeError: Error {
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

enum TranscribeError: Error {
    case noTranscriptionResponse
    case readError
    case parseError
    case invalidCredentials

    // MARK: - Computed Properties

    var errorDescription: String? {
        switch self {
        case .noTranscriptionResponse:
            "AWS에서 트랜스크립션 응답을 반환하지 않았음."
        case .readError:
            "입력 파일 읽기 오류"
        case .invalidCredentials:
            "AWS 인증 정보가 유효하지 않음"
        case .parseError:
            "결과 JSON 파싱 오류"
        }
    }
}
