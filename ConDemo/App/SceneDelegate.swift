//
//  SceneDelegate.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit
import Intents

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Functions
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        // 윈도우 생성
        let window: UIWindow = .init(windowScene: windowScene)
        self.window = window
        
        // 시리를 통해 앱이 실행되었는지 확인
        let launchedFromSiri = checkIfLaunchedFromSiri(options: connectionOptions)
        
        if launchedFromSiri {
            // 시리로 실행된 경우 RecordingMainViewController로 직접 이동
            setupDirectNavigationToRecordingMain(window: window)
        } else {
            // 일반 실행의 경우 LaunchViewController로 시작
            window.rootViewController = LaunchViewController()
            window.makeKeyAndVisible()
        }
        
        // 인텐트 기부
        donateIntent()
    }

    // 시리를 통해 앱이 실행되었는지 확인하는 헬퍼 메서드
    private func checkIfLaunchedFromSiri(options connectionOptions: UIScene.ConnectionOptions) -> Bool {
        // 사용자 활동(activity) 확인 - 앱이 시리를 통해 시작된 경우
        if let userActivity = connectionOptions.userActivities.first {
            // 1. 인텐트를 통한 실행 확인
            if let interaction = userActivity.interaction,
               interaction.intent is INIntent { // 모든 인텐트 타입 확인
                return true
            }
            
            // 2. activityType 확인 (Siri 앱 실행)
            if userActivity.activityType == "com.apple.intent.action.OPEN_APPLICATION" {
                return true
            }
        }
        
        return false
    }

    // RecordingMainViewController로 직접 이동하는 설정
    private func setupDirectNavigationToRecordingMain(window: UIWindow) {
        // RecordingLandingViewController를 네비게이션의 루트로 설정
        let landingVM = RecordingLandingViewModel()
        let landingVC = RecordingLandingViewController(viewModel: landingVM)
        let navController = UINavigationController(rootViewController: landingVC)
        
        // 네비게이션 컨트롤러를 윈도우의 루트뷰 컨트롤러로 설정
        window.rootViewController = navController
        
        // 마이크 권한 확인 후 RecordingMainViewController로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            landingVC.checkMicrophoneAuthorizationStatus {
                let recordingVM = RecordingMainViewModel()
                let recordingVC = RecordingMainViewController(recordingVM)
                navController.pushViewController(recordingVC, animated: false)
                
                window.makeKeyAndVisible()
            }
        }
    }

    // 이미 실행 중인 앱이 시리를 통해 활성화될 때
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        // 앱이 이미 실행 중일 때 시리로 활성화된 경우
        if userActivity.activityType == "com.apple.intent.action.OPEN_APPLICATION" ||
           userActivity.interaction?.intent is INIntent {
            navigateToRecordingMain()
        }
    }

    // RecordingMainViewController로 이동
    private func navigateToRecordingMain() {
        guard let rootVC = window?.rootViewController else { return }
        
        // 이미 네비게이션 컨트롤러가 있는 경우
        if let navController = rootVC as? UINavigationController {
            // 현재 RecordingMainViewController가 표시되고 있는지 확인
            if navController.viewControllers.last is RecordingMainViewController {
                return // 이미 RecordingMainViewController가 표시되고 있으면 아무 작업 안 함
            }
            
            // RecordingLandingViewController가 루트인지 확인
            if let landingVC = navController.viewControllers.first as? RecordingLandingViewController {
                let recordingVM = RecordingMainViewModel()
                let recordingVC = RecordingMainViewController(recordingVM)
                
                // 현재 스택의 모든 뷰 컨트롤러를 루트와 새 RecordingMainViewController로 대체
                navController.setViewControllers([landingVC, recordingVC], animated: false)
                return
            }
        }
        
        // 네비게이션 컨트롤러가 없거나 예상과 다른 구조인 경우, 새로 설정
        let landingVM = RecordingLandingViewModel()
        let landingVC = RecordingLandingViewController(viewModel: landingVM)
        let navController = UINavigationController(rootViewController: landingVC)
        
        // 마이크 권한 확인 후 RecordingMain으로 이동
        landingVC.checkMicrophoneAuthorizationStatus {
            let recordingVM = RecordingMainViewModel()
            let recordingVC = RecordingMainViewController(recordingVM)
            navController.pushViewController(recordingVC, animated: false)
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
        }
    }
//
//    func scene(_ scene: UIScene, willConnectTo _: UISceneSession,
//               options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else {
//            return
//        }
//        
//        let window: UIWindow = .init(windowScene: windowScene)
//        window.rootViewController = LaunchViewController()
//        window.makeKeyAndVisible()
//        self.window = window
//        
//        if let userActivity = connectionOptions.userActivities.first,
//           let interaction = userActivity.interaction,
//           interaction.intent is StartRecordingIntentIntent {
//            // 앱이 시작되면 LaunchViewController에서 확인할 수 있는 플래그 설정
//            UserDefaults.standard.set(true, forKey: "LaunchFromSiri")
//        }
//        
//        donateIntent()
//    }
//    
    func donateIntent() {
        let intent = StartRecordingIntentIntent()
        intent.suggestedInvocationPhrase = "트러블 열어줘"
        
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { (error) in
            if let error = error {
                print("인텐트 기부 실패: \(error.localizedDescription)")
            } else {
                print("인텐트 기부 성공")
            }
        }
    }
    
    func simulateSiriLaunch() {
        print("시리 실행 시뮬레이션 시작")
        // RecordingMainViewController로 직접 이동
        navigateToRecordingMain()
    }
//
//    // 앱이 인텐트로 열렸을 때 처리
//    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
//        // 인텐트 처리
//        if let interaction = userActivity.interaction,
//           interaction.intent is StartRecordingIntentIntent {
//            navigateToRecordingVC()
//        }
////        navigateToRecordingVC()
//    }
//    
//    func navigateToRecordingVC() {
//        guard let rootVC = window?.rootViewController else {
//            print("루트 뷰 컨트롤러를 찾을 수 없음")
//            return
//        }
//        
//        // LaunchViewController인 경우 플래그 설정
//        if rootVC is LaunchViewController {
//            UserDefaults.standard.set(true, forKey: "LaunchFromSiri")
//            return // LaunchViewController가 플래그를 확인하고 처리할 것임
//        }
//        
//        // 이미 다른 화면이 표시된 상태라면 RecordingMainViewController로 이동
//        let landingVM = RecordingLandingViewModel()
//        let landingVC = RecordingLandingViewController(viewModel: landingVM)
//        let navigationController = UINavigationController(rootViewController: landingVC)
//        
//        // 마이크 권한 확인 후 RecordingMainViewController로 이동
//        landingVC.checkMicrophoneAuthorizationStatus { [weak self] in
//            let recordingVM = RecordingMainViewModel()
//            let recordingVC = RecordingMainViewController(recordingVM)
//            navigationController.pushViewController(recordingVC, animated: false)
//            self?.window?.rootViewController = navigationController
//            self?.window?.makeKeyAndVisible()
//        }
//    }
    
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
