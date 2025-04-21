//
//  MessageData.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import CoreData
import Foundation
import UIKit

struct MessageData {
    // MARK: - Properties

    let id: String?
    let text: String
    let isFromCurrentUser: Bool
    let timestamp: Date?
    let image: UIImage?
    let audioURL: URL?
    let audioData: Data?

    // MARK: - Lifecycle

    init(id: String = UUID().uuidString, text: String, isFromCurrentUser: Bool,
         timestamp: Date = Date(), image: UIImage? = nil, audioURL: URL? = nil,
         audioData: Data? = nil) {
        self.id = id
        self.text = text
        self.isFromCurrentUser = isFromCurrentUser
        self.timestamp = timestamp
        self.image = image
        self.audioURL = audioURL
        self.audioData = audioData
    }
}

// MARK: - 더미 데이터

extension MessageData {
    static var dummyMessages: [MessageData] {
        let calendar: Calendar = .current
        let now: Date = .init()

        return [
            MessageData(text: "여보, 오늘도 집안일 다 내가 했어. 당신은 왜 도와주지 않는 거야?", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -118, to: now)!),
            
            MessageData(text: "나도 일 끝나고 너무 피곤해서 그랬어. 내일은 도와줄게.", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -116, to: now)!),
            
            MessageData(text: "항상 내일, 내일 그러면서 안 도와주잖아. 나도 일하고 와서 피곤하다고.", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -115, to: now)!),
            
            MessageData(text: "당신 일과 내 일이 같냐? 내가 얼마나 스트레스 받는데...", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -113, to: now)!),
            
            MessageData(text: "또 그 얘기야? 내 일이 편하다고 생각하는 거야?", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -112, to: now)!),
            
            // 부부싸움 시나리오 2: 지출 문제
            MessageData(text: "카드 명세서 봤어. 왜 이렇게 많이 썼어?", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -100, to: now)!),
            
            MessageData(text: "아이들 학원비랑 생필품 사는데 들어간 거야.", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -98, to: now)!),
            
            MessageData(text: "이번 달에 예산 초과했잖아. 조금만 절약할 수 없어?", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -97, to: now)!),
            
            MessageData(text: "나도 아끼려고 노력하는데, 당신은 커피 마시는 데 얼마나 쓰는데?", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -95, to: now)!),
            
            MessageData(text: "내가 스트레스 풀려고 커피 한 잔 마시는 것도 뭐라 그래?", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -93, to: now)!),
            
            // 부부싸움 시나리오 3: 시댁/처가 문제
            MessageData(text: "이번 주말에 우리 부모님 뵈러 가야 할 것 같아.", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -80, to: now)!),
            
            MessageData(text: "또? 지난 주말에도 갔잖아. 이번엔 좀 쉬고 싶은데...", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -78, to: now)!),
            
            MessageData(text: "당신은 왜 우리 부모님 만나기 싫어하는 거야?", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -77, to: now)!),
            
            MessageData(text: "싫어하는 게 아니라 너무 자주 가니까 그렇지. 우리 부모님은 거의 안 만나면서.", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -75, to: now)!),
            
            MessageData(text: "그건 당신 부모님이 멀리 계시잖아. 내가 어떡하라고.", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -73, to: now)!),
            
            // 부부싸움 시나리오 4: 육아 방식 갈등
            MessageData(text: "아이한테 왜 그렇게 화를 내? 아이 교육에 좋지 않아.", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -60, to: now)!),
            
            MessageData(text: "내가 언제 화냈어? 그냥 규칙을 알려준 것뿐이야.", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -58, to: now)!),
            
            MessageData(text: "목소리 톤이 높아지면서 아이가 무서워했잖아.", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -57, to: now)!),
            
            MessageData(text: "당신은 너무 아이를 응석받이로 키우려고 해. 규칙도 필요해.", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -55, to: now)!),
            
            MessageData(text: "나도 규칙이 필요하다는 건 알아. 근데 방식이 너무 강압적이야.", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -53, to: now)!),
            
            // 부부싸움 시나리오 5: 친구와의 약속
            MessageData(text: "오늘 저녁에 친구들 만나고 올게.", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -40, to: now)!),
            
            MessageData(text: "또? 이번 주에만 벌써 두 번째잖아.", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -38, to: now)!),
            
            MessageData(text: "나도 사회생활이 있잖아. 무슨 문제라도?", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -37, to: now)!),
            
            MessageData(text: "나는 집에서 아이들 돌보는데 당신만 놀러 다니는 것 같아서 서운해.", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -35, to: now)!),
            
            MessageData(text: "내가 일하고 스트레스 풀려고 그러는 건데 이해 좀 해줘.", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -33, to: now)!),
            
            // 부부싸움 시나리오 6: 늦게 귀가
            MessageData(text: "또 연락도 없이 이렇게 늦게 들어오는 거야?", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -20, to: now)!),
            
            MessageData(text: "회식이 길어졌어. 미안해.", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -18, to: now)!),
            
            MessageData(text: "전화 한 통 못해? 얼마나 걱정했는지 알아?", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -17, to: now)!),
            
            MessageData(text: "배터리가 없었어. 이해 좀 해줘.", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -15, to: now)!),
            
            MessageData(text: "항상 그런 핑계만 대네. 정말 실망이야.", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -13, to: now)!),
            
            // 화해 시도
            MessageData(text: "미안해. 다음부턴 꼭 연락할게.", isFromCurrentUser: true,
                       timestamp: calendar.date(byAdding: .minute, value: -5, to: now)!),
            
            MessageData(text: "알았어. 그리고 나도 아까 좀 심했어. 미안해.", isFromCurrentUser: false,
                       timestamp: calendar.date(byAdding: .minute, value: -3, to: now)!)
        ]
    }
}
