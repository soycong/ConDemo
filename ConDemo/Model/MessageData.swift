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

        return [MessageData(text: "야, 내 프로젝트 자료 왜 마음대로 수정한 거야?", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -120, to: now)!),
                MessageData(text: "뭐? 난 그냥 도와주려고 했던 건데...", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -119, to: now)!),
                MessageData(text: "도움? 이거 완전 망쳐놨잖아! 이제 처음부터 다시 해야 된다고!", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -117, to: now)!),
                MessageData(text: "그렇게 화낼 일인지 모르겠네. 내가 보기엔 더 좋아진 것 같은데.", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -116, to: now)!),
                MessageData(text: "너 진짜 내 상황 몰라주네. 이거 내일까지 제출해야 하는 거라고!", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -114, to: now)!),
                MessageData(text: "그럼 미리 말했어야지! 어떻게 내가 알겠어?", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -113, to: now)!),
                MessageData(text: "아니, 기본적인 매너지. 남의 파일 함부로 건드리지 않는 게...", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -112, to: now)!),
                MessageData(text: "매너? 너야말로 고마움을 표현할 줄 알아야 하는 거 아니야?", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -110, to: now)!),
                MessageData(text: "뭔 고마움? 이거 망쳐놓고 고맙다고 해?", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -108, to: now)!),
                MessageData(text: "알았어. 내가 미안하다고 할게. 그런데 너무 예민하게 반응하는 거 아니야?",
                            isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -105, to: now)!),
                MessageData(text: "예민? 내 하루 일과가 다 망가졌는데?", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -103, to: now)!),
                MessageData(text: "그래도 그렇게까지... 아무튼 내가 도와줄게. 같이 고쳐보자.", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -100, to: now)!),
                MessageData(text: "됐어. 이미 백업본 찾았으니까 혼자 할게.", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -95, to: now)!),
                MessageData(text: "너 진짜... 도와주려는 사람한테 그렇게 대하면 돼?", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -93, to: now)!),
                MessageData(text: "도움 요청한 적 없어. 그냥 내 일에 간섭하지 마.", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -90, to: now)!),
                MessageData(text: "와, 정말 너랑은 대화가 안 통하네. 다시는 안 도와줄 거야.", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -87, to: now)!),
                MessageData(text: "그래, 그게 제일 좋겠다.", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -85, to: now)!),
                MessageData(text: "...", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -80, to: now)!),
                MessageData(text: "미안해. 내가 너무 과하게 반응했어.", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -70, to: now)!),
                MessageData(text: "괜찮아. 나도 허락 없이 파일을 수정해서 미안해.", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -68, to: now)!),
                MessageData(text: "우리 이제 화해할까?", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -65, to: now)!),
                MessageData(text: "그래. 앞으로는 이런 일 없도록 서로 더 조심하자.", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -63, to: now)!),
                MessageData(text: "알겠어. 내일 점심 같이 먹을래?", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -60, to: now)!),
                MessageData(text: "좋아. 내가 살게!", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -58, to: now)!),
                MessageData(text: "화해 완료! 😊", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -55, to: now)!),
                MessageData(text: "그런데 사실... 프로젝트 마감이 오늘이라며? 내일 아니고?", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -50, to: now)!),
                MessageData(text: "뭐?! 맞아... 오늘이었어! 망했다!!", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -48, to: now)!),
                MessageData(text: "진정해. 내가 지금 가서 도와줄게. 어디야?", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -45, to: now)!),
                MessageData(text: "도서관 3층. 빨리 와줘... 제발...", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -43, to: now)!),
                MessageData(text: "알았어! 30분 안에 도착할게. 커피 가져갈까?", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -40, to: now)!),
                MessageData(text: "아메리카노 부탁해... 평소보다 샷 두 번 추가로...", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -38, to: now)!),
                MessageData(text: "ㅋㅋㅋ 알겠어. 금방 갈게!", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -36, to: now)!),
                MessageData(text: "진짜 고마워... 이제 친구 맞네...", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -34, to: now)!),
                MessageData(text: "당연하지! 싸워도 우정은 계속되는 거야.", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -30, to: now)!),
                MessageData(text: "야, 내 프로젝트 자료 왜 마음대로 수정한 거야?", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -120, to: now)!),
                MessageData(text: "뭐? 난 그냥 도와주려고 했던 건데...", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -119, to: now)!),
                MessageData(text: "도움? 이거 완전 망쳐놨잖아! 이제 처음부터 다시 해야 된다고!", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -117, to: now)!),
                MessageData(text: "그렇게 화낼 일인지 모르겠네. 내가 보기엔 더 좋아진 것 같은데.", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -116, to: now)!),
                MessageData(text: "너 진짜 내 상황 몰라주네. 이거 내일까지 제출해야 하는 거라고!", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -114, to: now)!),
                MessageData(text: "그럼 미리 말했어야지! 어떻게 내가 알겠어?", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -113, to: now)!),
                MessageData(text: "아니, 기본적인 매너지. 남의 파일 함부로 건드리지 않는 게...", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -112, to: now)!),
                MessageData(text: "매너? 너야말로 고마움을 표현할 줄 알아야 하는 거 아니야?", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -110, to: now)!),
                MessageData(text: "뭔 고마움? 이거 망쳐놓고 고맙다고 해?", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -108, to: now)!),
                MessageData(text: "알았어. 내가 미안하다고 할게. 그런데 너무 예민하게 반응하는 거 아니야?",
                            isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -105, to: now)!),
                MessageData(text: "예민? 내 하루 일과가 다 망가졌는데?", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -103, to: now)!),
                MessageData(text: "그래도 그렇게까지... 아무튼 내가 도와줄게. 같이 고쳐보자.", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -100, to: now)!),
                MessageData(text: "됐어. 이미 백업본 찾았으니까 혼자 할게.", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -95, to: now)!),
                MessageData(text: "너 진짜... 도와주려는 사람한테 그렇게 대하면 돼?", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -93, to: now)!),
                MessageData(text: "도움 요청한 적 없어. 그냥 내 일에 간섭하지 마.", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -90, to: now)!),
                MessageData(text: "와, 정말 너랑은 대화가 안 통하네. 다시는 안 도와줄 거야.", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -87, to: now)!),
                MessageData(text: "그래, 그게 제일 좋겠다.", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -85, to: now)!),
                MessageData(text: "...", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -80, to: now)!),
                MessageData(text: "미안해. 내가 너무 과하게 반응했어.", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -70, to: now)!),
                MessageData(text: "괜찮아. 나도 허락 없이 파일을 수정해서 미안해.", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -68, to: now)!),
                MessageData(text: "우리 이제 화해할까?", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -65, to: now)!),
                MessageData(text: "그래. 앞으로는 이런 일 없도록 서로 더 조심하자.", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -63, to: now)!),
                MessageData(text: "알겠어. 내일 점심 같이 먹을래?", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -60, to: now)!),
                MessageData(text: "좋아. 내가 살게!", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -58, to: now)!),
                MessageData(text: "화해 완료! 😊", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -55, to: now)!),
                MessageData(text: "그런데 사실... 프로젝트 마감이 오늘이라며? 내일 아니고?", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -50, to: now)!),
                MessageData(text: "뭐?! 맞아... 오늘이었어! 망했다!!", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -48, to: now)!),
                MessageData(text: "진정해. 내가 지금 가서 도와줄게. 어디야?", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -45, to: now)!),
                MessageData(text: "도서관 3층. 빨리 와줘... 제발...", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -43, to: now)!),
                MessageData(text: "알았어! 30분 안에 도착할게. 커피 가져갈까?", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -40, to: now)!),
                MessageData(text: "아메리카노 부탁해... 평소보다 샷 두 번 추가로...", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -38, to: now)!),
                MessageData(text: "ㅋㅋㅋ 알겠어. 금방 갈게!", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -36, to: now)!),
                MessageData(text: "진짜 고마워... 이제 친구 맞네...", isFromCurrentUser: true,
                            timestamp: calendar.date(byAdding: .minute, value: -34, to: now)!),
                MessageData(text: "당연하지! 싸워도 우정은 계속되는 거야.", isFromCurrentUser: false,
                            timestamp: calendar.date(byAdding: .minute, value: -30, to: now)!)]
    }
}
