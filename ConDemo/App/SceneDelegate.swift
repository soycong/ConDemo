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
        // 앱 시작 시 ChatGPTManager 테스트 실행
        testChatGPTManager()
        // testTranscriptAnalyzer()
    }
            
            // ChatGPTManager 테스트 함수
    private func testChatGPTManager() {
        print("===== ChatGPTManager 테스트 시작 =====")
        
        // 테스트 대화 생성
        //        let testMessages: [MessageData] = [
        //            MessageData(text: "다음 주에 엄마 생신이라서 친정 좀 다녀오려고 하는데?", isFromCurrentUser: false),
        //            MessageData(text: "또 친정이야? 이번 달에만 벌써 세 번째잖아.", isFromCurrentUser: true),
        //            MessageData(text: "내 엄마 생신인데 그게 뭐가 문제야? 가족 행사인데 당연히 가야지.", isFromCurrentUser: false),
        //            MessageData(text: "우리 부모님 생신 땐 그렇게 반응 안 했잖아. 그땐 바쁘다고 같이 가지도 않았고.", isFromCurrentUser: true),
        //            MessageData(text: "그건 상황이 달랐잖아. 갑자기 일정이 겹쳐서 그런 거지, 내가 일부러 그런 것도 아니고.", isFromCurrentUser: false),
        //            MessageData(text: "그래도 난 서운했다. 적어도 같이 가려고 노력은 해야 하는 거 아니야?", isFromCurrentUser: true),
        //            MessageData(text: "서운한 건 네 자유지. 나도 네 행동 하나하나에 서운한 거 많은데 그냥 넘긴 거야.", isFromCurrentUser: false),
        //            MessageData(text: "그럼 얘기를 하지 왜 말도 안 하고 마음속에 담아두기만 해? 지금 이게 무슨 방식이야?", isFromCurrentUser: true),
        //            MessageData(text: "내가 말을 하면 네가 받아들이는 태도가 문제니까 그렇지. 언제 들어줬다고?", isFromCurrentUser: false),
        //            MessageData(text: "지금 말 돌리는 거지? 결국 또 내 탓 하려고?", isFromCurrentUser: true),
        //            MessageData(text: "아니, 현실을 말하는 거야. 넌 늘 네 입장만 생각하잖아. 뭘 하든 넌 옳고 나는 틀리고.", isFromCurrentUser: false),
        //            MessageData(text: "됐어. 더 얘기해봤자 또 너 말만 맞다고 끝날 테니까. 그냥 네 마음대로 해.", isFromCurrentUser: true),
        //            MessageData(text: "그래, 나도 더는 너한테 맞춰주고 싶지도 않아. 네가 뭘 느끼든 신경 쓰기 싫어졌어.", isFromCurrentUser: false)
        //        ]
        
        // 가사 분담에 대한 부부 싸움 대화
        let Messages: [MessageData] = [
            MessageData(text: "당신 오늘도 그냥 신발 아무 데나 벗어놨네?", isFromCurrentUser: false),
            MessageData(text: "어, 급하게 들어와서 그랬어. 나중에 정리할게.", isFromCurrentUser: true),
            MessageData(text: "나중에? 매번 그 말만 하고 결국 내가 치우잖아.", isFromCurrentUser: false),
            MessageData(text: "그렇게 신경 쓰이면 그냥 넘어가지 왜 매번 지적해?", isFromCurrentUser: true),
            MessageData(text: "넘어가? 내가 24시간 가사노동 하는 로봇인가? 당신도 같이 살면서 책임져야지.", isFromCurrentUser: false),
            MessageData(text: "나도 밖에서 일하고 와서 피곤한데 집에 오면 쉬고 싶다고.", isFromCurrentUser: true),
            MessageData(text: "나도 하루종일 일하고 애 보고 집안일 하는데 쉬고 싶어. 근데 누가 해야 하니까 하는 거지.", isFromCurrentUser: false),
            MessageData(text: "당신이 더 꼼꼼하니까 집안일은 당신이 주로 하는 게 효율적이잖아.", isFromCurrentUser: true),
            MessageData(text: "그래서 나한테 다 미루는 거야? 내가 꼼꼼한 건 타고난 게 아니라 노력하는 거야.", isFromCurrentUser: false),
            MessageData(text: "나도 도울 수 있는 건 돕고 있잖아. 지난번에 설거지도 했고.", isFromCurrentUser: true),
            MessageData(text: "설거지 한 번 한 걸 자랑으로 얘기하다니. 기본적인 생활을 도와준다고 생각하지 마.", isFromCurrentUser: false),
            MessageData(text: "왜 자꾸 트집 잡는데? 내가 그동안 얼마나 고생하는지 알기나 해?", isFromCurrentUser: true),
            MessageData(text: "당신 고생만 고생이야? 내 희생은 당연한 거고? 이제 정말 지쳤어.", isFromCurrentUser: false),
            MessageData(text: "그럼 어떻게 하자는 건데? 내가 직장 그만두고 집안일만 해?", isFromCurrentUser: true),
            MessageData(text: "그게 아니라 서로 분담하자는 거지. 가사노동표 만들어서 공평하게 나누자고.", isFromCurrentUser: false),
            MessageData(text: "그런 유치한 방법까지 써야 해? 그냥 상황 봐가면서 하면 되지.", isFromCurrentUser: true),
            MessageData(text: "상황 봐가면서 하면 결국 다 내 몫이 되는데? 이젠 정말 한계야.", isFromCurrentUser: false)
        ]
        
        let testMessages: [MessageData] = [
            MessageData(text: "이번 달 카드 명세서 확인해봤어? 무슨 쇼핑을 이렇게 많이 했어?", isFromCurrentUser: true),
            MessageData(text: "애들 새 학기 용품이랑 옷 사고, 집에 필요한 것들 좀 샀어.", isFromCurrentUser: false),
            MessageData(text: "근데 이게 다 필요한 거야? 50만원이나 썼네.", isFromCurrentUser: true),
            MessageData(text: "당신은 내가 뭘 사든 간섭하려고 들어. 다 필요해서 산 거야.", isFromCurrentUser: false),
            MessageData(text: "간섭이 아니라 우리 재정 상황이 그렇게 여유롭지 않잖아.", isFromCurrentUser: true),
            MessageData(text: "그럼 내가 애들 학용품도 안 사고 뭐만 입혀 보낼까? 체면이란 게 있지.", isFromCurrentUser: false),
            MessageData(text: "체면? 그게 지금 중요해? 저번 달에도 적자였는데.", isFromCurrentUser: true),
            MessageData(text: "당신은 맨날 돈 얘기만 해. 삶의 질은 생각 안 해?", isFromCurrentUser: false),
            MessageData(text: "삶의 질은 재정적 안정이 있어야 유지되는 거야. 앞으로도 이런 식이면 노후는 어떻게 준비해?", isFromCurrentUser: true),
            MessageData(text: "그래서 내가 뭘 사면 다 보고해야 된다는 거야? 나도 돈 벌어서 쓰는 건데.", isFromCurrentUser: false),
            MessageData(text: "우리 합의한 대로 큰 지출은 서로 상의하기로 했잖아.", isFromCurrentUser: true),
            MessageData(text: "그래, 큰 지출. 생필품 사는 게 큰 지출이야? 당신이 골프 치러 가는 건?", isFromCurrentUser: false),
            MessageData(text: "그건 업무 관계 유지를 위한 거고, 한 달에 한 번 가는 거잖아.", isFromCurrentUser: true),
            MessageData(text: "업무 관계? 그냥 인정해. 당신 놀고 싶어서 가는 거잖아.", isFromCurrentUser: false),
            MessageData(text: "왜 자꾸 말을 돌려? 지금 문제는 당신 과소비라고.", isFromCurrentUser: true),
            MessageData(text: "나 정말 지겨워. 매번 돈 쓸 때마다 눈치 보게 하지 마.", isFromCurrentUser: false),
            MessageData(text: "당신도 우리 가정의 미래를 좀 생각해봐. 이렇게 쓰다간 큰일 나.", isFromCurrentUser: true),
            MessageData(text: "알았어, 다신 안 쓸게. 그럼 당신이 다 알아서 해.", isFromCurrentUser: false)
        ]
        
        
        // 비동기 테스트 실행
        Task {
            do {
                print("대화 분석 요청 중...")
                // let analysisData = try await ChatGPTManager.shared.analyzeConversation(transcriptJson: Templates.sampleTranscript)
                let analysisData = try await ChatGPTManager.shared.createAnalysisDataFromTranscript(transcriptJson: Templates.sampleTranscript)
                
                // 결과 출력
                print("\n===== 분석 결과 =====")
                print("제목: \(analysisData.title)")
                print("쟁점: \(analysisData.contents)")
                print("격한 정도: \(analysisData.level)/10")
                
                // Polls 출력
                if let polls = analysisData.polls {
                    print("\n----- 투표 항목 (\(polls.count)개) -----")
                    for (index, poll) in polls.enumerated() {
                        print("[\(index+1)] \(poll.title)")
                        print("   내용: \(poll.contents)")
                        print("   나의 의견: \(poll.myOpinion)")
                        print("   상대방 의견: \(poll.yourOpinion)")
                        print("   옵션: \(poll.options.joined(separator: " | "))")
                        print("")
                    }
                }
                
                // 요약 출력
                if let summaries = analysisData.summaries, !summaries.isEmpty {
                    print("----- 커뮤니티 게시글 -----")
                    
                    // 내 관점의 요약
                    if let myPerspective = summaries.first(where: { $0.isCurrentUser }) {
                        print("■ 내 관점:")
                        print("제목: \(myPerspective.title)")
                        print("내용: \(myPerspective.contents)")
                    }
                    
                    // 상대방 관점의 요약
                    if let otherPerspective = summaries.first(where: { !$0.isCurrentUser }) {
                        print("\n■ 상대방 관점:")
                        print("제목: \(otherPerspective.title)")
                        print("내용: \(otherPerspective.contents)")
                    }
                }
                
                if let detailData = analysisData.detailedTranscriptAnalysisData {
                    
                    // 1. 말한 시간
                    print("▶ 대화 시간:")
                    print("  - 화자 A: \(detailData.speakingTime.speakerA)분")
                    print("  - 화자 B: \(detailData.speakingTime.speakerB)분")
                    
                    // 2. 말 겹침
                    print("\n▶ 말 겹침:")
                    print("  - 횟수: \(detailData.overlaps.count)회")
                    print("  - 총 겹친 시간: \(detailData.overlaps.totalDuration)초")
                    print("  - overlap Topics: \(detailData.overlapTopics)")
                    
                    // 3. 일관성 평가
                    print("\n▶ 일관성 평가:")
                    print("  - 화자 A: \(detailData.consistency.speakerA.score)/5")
                    print("  - 화자 A 근거: \(detailData.consistency.speakerA.reasoning)")
                    print("  - 화자 B: \(detailData.consistency.speakerB.score)/5")
                    print("  - 화자 B 근거: \(detailData.consistency.speakerB.reasoning)")
                    
                    // 4. 사실 관계 정확성
                    print("\n▶ 사실 관계 정확성:")
                    print("  - 화자 A: \(detailData.factualAccuracy.speakerA.score)/5")
                    print("  - 화자 A 근거: \(detailData.factualAccuracy.speakerA.reasoning)")
                    print("  - 화자 B: \(detailData.factualAccuracy.speakerB.score)/5")
                    print("  - 화자 B 근거: \(detailData.factualAccuracy.speakerB.reasoning)")
                    
                    // 5. 감정 분석
                    print("\n▶ 감정 분석:")
                    print("  - 화자 A: 긍정 \(Int(detailData.sentimentAnalysis.speakerA.positiveRatio * 100))% / 부정 \(Int(detailData.sentimentAnalysis.speakerA.negativeRatio * 100))%")
                    print("  - 화자 A: 긍정 단어 \(detailData.sentimentAnalysis.speakerA.positiveExamples)/ 부정 단어 \(detailData.sentimentAnalysis.speakerA.negativeExamples)/")
                    print("  - 화자 B: 긍정 \(Int(detailData.sentimentAnalysis.speakerB.positiveRatio * 100))% / 부정 \(Int(detailData.sentimentAnalysis.speakerB.negativeRatio * 100))%")
                    print("  - 화자 B: 긍정 단어 \(detailData.sentimentAnalysis.speakerB.positiveExamples)/ 부정 단어 \(detailData.sentimentAnalysis.speakerB.negativeExamples)/")
                    
                    // 6. 틀린 사용
                    print("\n▶ 잘못된 사용:")
                    print("  - 화자 A 횟수: \(detailData.incorrectUsage.speakerA.count)")
                    print("  - 화자 A 예시: \(detailData.incorrectUsage.speakerA.examples)")
                    print("  - 화자 B 횟수: \(detailData.incorrectUsage.speakerB.count)")
                    print("  - 화자 B 예시: \(detailData.incorrectUsage.speakerB.examples)")
                }
                
                print("\n===== 테스트 완료 =====")
                                
                // CoreData에 저장 테스트
                let savedTitle = CoreDataManager.shared.saveAnalysis(data: analysisData)
                print("CoreData 저장 완료: \(savedTitle)")
                
                // 저장된 데이터 출력
                // CoreDataManager.shared.printAllAnalyses()
                
            } catch {
                print("ChatGPTManager 테스트 실패: \(error)")
            }
        }
    }
    
    // 트랜스크립트 분석기 테스트 - 간결한 버전
    private func testTranscriptAnalyzer() {
        print("===== TranscriptAnalyzer 테스트 시작 =====")
        
//        // 샘플 AWS Transcribe JSON
//        let sampleTranscript = """
//        {
//          "jobName": "sample-transcription",
//          "results": {
//            "items": [
//              {
//                "start_time": 0.0,
//                "end_time": 5.2,
//                "alternatives": [
//                  {
//                    "confidence": 0.95,
//                    "content": "안녕하세요, 오늘 회의에 참석해 주셔서 감사합니다."
//                  }
//                ],
//                "speaker_label": "spk_0"
//              },
//              {
//                "start_time": 5.5,
//                "end_time": 10.3,
//                "alternatives": [
//                  {
//                    "confidence": 0.92,
//                    "content": "네, 반갑습니다. 저희가 오늘 어떤 안건을 논의할 예정인가요?"
//                  }
//                ],
//                "speaker_label": "spk_1"
//              },
//              {
//                "start_time": 10.1,
//                "end_time": 15.7,
//                "alternatives": [
//                  {
//                    "confidence": 0.89,
//                    "content": "오늘은 신제품 출시 일정과 마케팅 전략에 대해 이야기해 볼 생각입니다."
//                  }
//                ],
//                "speaker_label": "spk_0"
//              },
//              {
//                "start_time": 15.2,
//                "end_time": 20.4,
//                "alternatives": [
//                  {
//                    "confidence": 0.91,
//                    "content": "좋습니다. 제가 준비한 자료도 있는데, 신제품은 예상보다 개발이 늦어지고 있어요."
//                  }
//                ],
//                "speaker_label": "spk_1"
//              }
//            ],
//            "speaker_labels": {
//              "speakers": 2,
//              "segments": [
//                {
//                  "start_time": 0.0,
//                  "end_time": 5.2,
//                  "speaker_label": "spk_0"
//                },
//                {
//                  "start_time": 5.5,
//                  "end_time": 10.3,
//                  "speaker_label": "spk_1"
//                },
//                {
//                  "start_time": 10.1,
//                  "end_time": 15.7,
//                  "speaker_label": "spk_0"
//                },
//                {
//                  "start_time": 15.2,
//                  "end_time": 20.4,
//                  "speaker_label": "spk_1"
//                }
//              ]
//            }
//          }
//        }
//        """
        
        // 샘플 AWS Transcribe JSON - TV 리모컨 쟁탈전 부부 싸움
//        let sampleTranscript = """
//        {
//          "jobName": "remote-control-fight-transcription",
//          "results": {
//            "items": [
//              {
//                "start_time": 0.0,
//                "end_time": 3.2,
//                "alternatives": [
//                  {
//                    "confidence": 0.96,
//                    "content": "야, 내가 보고 있던 드라마인데 왜 채널을 바꿔?"
//                  }
//                ],
//                "speaker_label": "spk_0"
//              },
//              {
//                "start_time": 3.0,
//                "end_time": 5.8,
//                "alternatives": [
//                  {
//                    "confidence": 0.92,
//                    "content": "무슨 소리야, 지금 축구 중계 시작하는 시간이잖아."
//                  }
//                ],
//                "speaker_label": "spk_1"
//              },
//              {
//                "start_time": 5.5,
//                "end_time": 8.9,
//                "alternatives": [
//                  {
//                    "confidence": 0.94,
//                    "content": "내가 매주 이 시간에 드라마 본다고 몇 번을 말했는데!"
//                  }
//                ],
//                "speaker_label": "spk_0"
//              },
//              {
//                "start_time": 8.6,
//                "end_time": 12.1,
//                "alternatives": [
//                  {
//                    "confidence": 0.91,
//                    "content": "오늘은 4강전이라 정말 중요한 경기라고. 나중에 재방송으로 보면 안 돼?"
//                  }
//                ],
//                "speaker_label": "spk_1"
//              },
//              {
//                "start_time": 11.8,
//                "end_time": 15.5,
//                "alternatives": [
//                  {
//                    "confidence": 0.93,
//                    "content": "재방송? 그럼 내일 모두가 결말 얘기할 때 나만 모르게? 이번 주가 시즌 피날레라고!"
//                  }
//                ],
//                "speaker_label": "spk_0"
//              },
//              {
//                "start_time": 15.2,
//                "end_time": 18.7,
//                "alternatives": [
//                  {
//                    "confidence": 0.89,
//                    "content": "그럼 TV는 내가 보고 넌 넷플릭스 태블릿으로 보면 되잖아."
//                  }
//                ],
//                "speaker_label": "spk_1"
//              },
//              {
//                "start_time": 18.4,
//                "end_time": 22.9,
//                "alternatives": [
//                  {
//                    "confidence": 0.95,
//                    "content": "왜 늘 내가 양보해야 돼? 지난주에도 내가 태블릿으로 봤잖아. 이번엔 네가 태블릿으로 봐."
//                  }
//                ],
//                "speaker_label": "spk_0"
//              },
//              {
//                "start_time": 22.6,
//                "end_time": 26.8,
//                "alternatives": [
//                  {
//                    "confidence": 0.90,
//                    "content": "스포츠는 큰 화면으로 봐야 제맛이지. 그리고 너는 매주 드라마 보지만 이 경기는 4년에 한 번이라고."
//                  }
//                ],
//                "speaker_label": "spk_1"
//              },
//              {
//                "start_time": 26.5,
//                "end_time": 30.7,
//                "alternatives": [
//                  {
//                    "confidence": 0.92,
//                    "content": "그러니까 중요하다면 제대로 녹화해두든가! 매번 이럴 거면 TV를 하나 더 사자고 내가 몇 번이나 말했어!"
//                  }
//                ],
//                "speaker_label": "spk_0"
//              },
//              {
//                "start_time": 30.3,
//                "end_time": 33.9,
//                "alternatives": [
//                  {
//                    "confidence": 0.88,
//                    "content": "지금 TV 살 돈이 어딨다고. 그냥 이번만 양보해주면 안 돼? 다음에는 내가 양보할게."
//                  }
//                ],
//                "speaker_label": "spk_1"
//              }
//            ],
//            "speaker_labels": {
//              "speakers": 2,
//              "segments": [
//                {
//                  "start_time": 0.0,
//                  "end_time": 3.2,
//                  "speaker_label": "spk_0"
//                },
//                {
//                  "start_time": 3.0,
//                  "end_time": 5.8,
//                  "speaker_label": "spk_1"
//                },
//                {
//                  "start_time": 5.5,
//                  "end_time": 8.9,
//                  "speaker_label": "spk_0"
//                },
//                {
//                  "start_time": 8.6,
//                  "end_time": 12.1,
//                  "speaker_label": "spk_1"
//                },
//                {
//                  "start_time": 11.8,
//                  "end_time": 15.5,
//                  "speaker_label": "spk_0"
//                },
//                {
//                  "start_time": 15.2,
//                  "end_time": 18.7,
//                  "speaker_label": "spk_1"
//                },
//                {
//                  "start_time": 18.4,
//                  "end_time": 22.9,
//                  "speaker_label": "spk_0"
//                },
//                {
//                  "start_time": 22.6,
//                  "end_time": 26.8,
//                  "speaker_label": "spk_1"
//                },
//                {
//                  "start_time": 26.5,
//                  "end_time": 30.7,
//                  "speaker_label": "spk_0"
//                },
//                {
//                  "start_time": 30.3,
//                  "end_time": 33.9,
//                  "speaker_label": "spk_1"
//                }
//              ]
//            }
//          }
//        }
//        """
//
        
        // 비동기 테스트 실행
        Task {
            do {
                print("트랜스크립트 분석 요청 중...")
                let analysisData = try await ChatGPTManager.shared.analyzeTranscriptJSON(transcriptJson: Templates.sampleTranscript)
                
                // 결과 요약 출력
                print("\n===== 분석 결과 요약 =====")
                
                // 1. 말한 시간
                print("▶ 대화 시간:")
                print("  - 화자 A: \(analysisData.speakingTime.speakerA)분")
                print("  - 화자 B: \(analysisData.speakingTime.speakerB)분")
                
                // 2. 말 겹침
                print("\n▶ 말 겹침:")
                print("  - 횟수: \(analysisData.overlaps.count)회")
                print("  - 총 겹친 시간: \(analysisData.overlaps.totalDuration)초")
                print("  - overlap Topics: \(analysisData.overlapTopics)")
                
                // 3. 일관성 평가
                print("\n▶ 일관성 평가:")
                print("  - 화자 A: \(analysisData.consistency.speakerA.score)/5")
                print("  - 화자 A 근거: \(analysisData.consistency.speakerA.reasoning)")
                print("  - 화자 B: \(analysisData.consistency.speakerB.score)/5")
                print("  - 화자 B 근거: \(analysisData.consistency.speakerB.reasoning)")
                
                // 4. 사실 관계 정확성
                print("\n▶ 사실 관계 정확성:")
                print("  - 화자 A: \(analysisData.factualAccuracy.speakerA.score)/5")
                print("  - 화자 A 근거: \(analysisData.factualAccuracy.speakerA.reasoning)")
                print("  - 화자 B: \(analysisData.factualAccuracy.speakerB.score)/5")
                print("  - 화자 B 근거: \(analysisData.factualAccuracy.speakerB.reasoning)")
                
                // 5. 감정 분석
                print("\n▶ 감정 분석:")
                print("  - 화자 A: 긍정 \(Int(analysisData.sentimentAnalysis.speakerA.positiveRatio * 100))% / 부정 \(Int(analysisData.sentimentAnalysis.speakerA.negativeRatio * 100))%")
                print("  - 화자 A: 긍정 단어 \(analysisData.sentimentAnalysis.speakerA.positiveExamples)/ 부정 단어 \(analysisData.sentimentAnalysis.speakerA.negativeExamples)/")
                print("  - 화자 B: 긍정 \(Int(analysisData.sentimentAnalysis.speakerB.positiveRatio * 100))% / 부정 \(Int(analysisData.sentimentAnalysis.speakerB.negativeRatio * 100))%")
                print("  - 화자 B: 긍정 단어 \(analysisData.sentimentAnalysis.speakerB.positiveExamples)/ 부정 단어 \(analysisData.sentimentAnalysis.speakerB.negativeExamples)/")
                
                // 6. 틀린 사용
                print("\n▶ 잘못된 사용:")
                print("  - 화자 A 횟수: \(analysisData.incorrectUsage.speakerA.count)")
                print("  - 화자 A 예시: \(analysisData.incorrectUsage.speakerA.examples)")
                print("  - 화자 B 횟수: \(analysisData.incorrectUsage.speakerB.count)")
                print("  - 화자 B 예시: \(analysisData.incorrectUsage.speakerB.examples)")
                
                print("\n===== 테스트 완료 =====")
                
            } catch {
                print("TranscriptAnalyzer 테스트 실패: \(error)")
            }
        }
    }

    // 실제 파일에서 트랜스크립트 분석 테스트 - 간결한 버전
    private func testTranscriptAnalyzerWithFile(filePath: String) {
        print("===== 파일 기반 트랜스크립트 분석 테스트 시작 =====")
        
        Task {
            do {
                // 파일에서 JSON 로드
                let fileURL = URL(fileURLWithPath: filePath)
                let jsonData = try Data(contentsOf: fileURL)
                let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
                
                print("AWS Transcribe 결과 로드 성공 (\(jsonString.count) 바이트), 분석 중...")
                
                // 분석 실행
                let result = try await ChatGPTManager.shared.analyzeTranscriptJSON(transcriptJson: jsonString)
                
                // 주요 결과만 출력
                print("\n===== 분석 결과 =====")
                print("▶ 화자 A 말한 시간: \(result.speakingTime.speakerA)분")
                print("▶ 화자 B 말한 시간: \(result.speakingTime.speakerB)분")
                print("▶ 말 겹침 횟수: \(result.overlaps.count)회")
                print("▶ 주요 겹친 주제: \(result.overlapTopics.prefix(2).joined(separator: ", "))")
                print("▶ 화자 A 일관성: \(result.consistency.speakerA.score)/5")
                print("▶ 화자 B 일관성: \(result.consistency.speakerB.score)/5")
                
                print("\n===== 테스트 완료 =====")
                
            } catch {
                print("파일 기반 분석 테스트 실패: \(error)")
            }
        }
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
