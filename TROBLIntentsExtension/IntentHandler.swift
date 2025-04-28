//
//  IntentHandler.swift
//  TROBLIntentsExtension
//
//  Created by 이명지 on 4/28/25.
//

import Intents

@objc protocol StartRecordingIntentHandling {
    @objc optional func confirm(intent: INIntent, completion: @escaping (INIntentResponse) -> Void)
    @objc optional func handle(intent: INIntent, completion: @escaping (INIntentResponse) -> Void)
}

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        // 정확한 타입 확인
        if intent is StartRecordingIntentIntent {
            return StartRecordingIntentHandler()
        }
        
        return self
    }
}

// StartRecordingIntent 처리기
class StartRecordingIntentHandler: NSObject, StartRecordingIntentIntentHandling {
    // 인텐트 확인
    func confirm(intent: StartRecordingIntentIntent, completion: @escaping (StartRecordingIntentIntentResponse) -> Void) {
        // 응답 객체 생성
        let response = StartRecordingIntentIntentResponse(code: .ready, userActivity: nil)
        completion(response)
    }

    func handle(intent: StartRecordingIntentIntent, completion: @escaping (StartRecordingIntentIntentResponse) -> Void) {
        let userActivity = NSUserActivity(activityType: "com.soycong.ConDemo.StartRecordingIntentIntent")
        userActivity.title = "녹음 시작"
        
        // .success 코드와 함께 응답 생성
        let response = StartRecordingIntentIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
}
