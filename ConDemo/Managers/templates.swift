//
//  templates.swift
//  ConDemo
//
//  Created by seohuibaek on 4/23/25.
//

struct Templates {
    static let analysisTemplate = """
            다음 두 사람 간의 대화 내용을 분석해 커뮤니티 콘텐츠로 변환해주세요:
            
            {transcript}
            
            응답은 반드시 다음 JSON 형식을 정확히 따라야 합니다:
            {
              "title": "대화 제목(한글 10자 이내)",
              "contents": "주요 쟁점 3가지를 매력적이고 재미있게 작성",
              "level": 1-10 사이의 숫자(싸움의 격한 정도),
              "polls": [
                {
                  "title": "첫 번째 쟁점 제목(매력적이고 자극적으로)",
                  "contents": "첫 번째 쟁점 설명(흥미롭게)",
                  "myOpinion": "첫 번째 화자의 의견(구체적으로)",
                  "yourOpinion": "두 번째 화자의 의견(구체적으로)",
                  "options": ["옵션1", "옵션2", "옵션3", "옵션4"]
                },
                {
                  "title": "두 번째 쟁점 제목(매력적이고 자극적으로)",
                  "contents": "두 번째 쟁점 설명(흥미롭게)",
                  "myOpinion": "첫 번째 화자의 의견(구체적으로)",
                  "yourOpinion": "두 번째 화자의 의견(구체적으로)",
                  "options": ["옵션1", "옵션2", "옵션3", "옵션4"]
                },
                {
                  "title": "세 번째 쟁점 제목(매력적이고 자극적으로)",
                  "contents": "세 번째 쟁점 설명(흥미롭게)",
                  "myOpinion": "첫 번째 화자의 의견(구체적으로)",
                  "yourOpinion": "두 번째 화자의 의견(구체적으로)",
                  "options": ["옵션1", "옵션2", "옵션3", "옵션4"]
                }
              ],
              "summaries": [
                {
                  "title": "나의 입장에서 바라본 자극적이고 매력적인 제목",
                  "contents": "나의 입장에서 커뮤니티 게시글 스타일의 논쟁(250자 이내)",
                  "isCurrentUser": true
                },
                {
                  "title": "상대방의 입장에서 바라본 자극적이고 매력적인 제목",
                  "contents": "상대방의 입장에서 커뮤니티 게시글 스타일의 논쟁(250자 이내)",
                  "isCurrentUser": false
                }
              ]
            }
            
            세부 지침:
            1️⃣ 대화 분석:
               - 제목은 한글로 10자 이내로 핵심을 담아 작성
               - 싸움의 격한 정도는 대화 톤과 내용에 따라 1~10 사이 숫자로 표현(대화가 없거나 온화한 경우 1)
               - 주요 쟁점 3가지를 이모지와 함께 흥미롭게 작성
            
            2️⃣ 투표(Poll) 생성:
               - 각 쟁점별로 정확히 하나씩, 총 3개의 poll 생성
               - 각 poll 제목은 유저의 호기심을 자극하고 클릭을 유도하는 스타일로 작성
               - 각 poll 옵션은 정확히 4개씩 생성하며, 공감되는 재미있는 선택지로 구성
               - 모든 옵션은 구어체로 작성하여 친근하고 선택하고 싶게 만들기
            
            3️⃣ 커뮤니티 요약:
               - 두 개의 요약을 생성: 나의 입장과 상대방의 입장 각각에서 본 내용
               - 각 요약의 제목은 SNS에서 공유하고 싶을 정도로 자극적이고 매력적으로 작성
               - 각 요약은 한 사람의 관점에서만 서술하여 주관적인 의견이 드러나도록 구성
               - 실제 커뮤니티 게시물처럼 공감과 흥미를 유발하는 스토리텔링 방식으로 작성
               - 대화 내용 중 인용구를 효과적으로 활용해 실제감 부여
               - 분석적 어조가 아닌 대화체로 작성하여 친근감 형성
            
            응답은 반드시 유효한 JSON 형식이어야 하며, 모든 필드를 포함해야 합니다. 이모지를 적절히 활용하여 각 섹션을 더 매력적으로 만들어주세요.
            
            {format_instructions}
            """
    
    static let detailTemplate = """
            당신은 회의, 인터뷰, 토론 등의 대화 내용을 심층 분석하는 전문가입니다. 제가 제공하는 AWS Transcribe 결과를 바탕으로 두 화자(A와 B)의 대화를 분석해주세요.

            다음은 분석할 AWS Transcribe JSON 결과입니다:

            {transcript}

            다음 항목들에 대해 정확하고 정량적인, JSON 형식의 분석 결과를 제공해주세요:

            1. 두 화자(A, B)가 각각 말한 시간(분 단위):
               - A가 말한 총 시간
               - B가 말한 총 시간

            2. 두 화자의 말이 겹친 횟수와 총 겹친 시간(초 단위)

            3. 두 화자의 말이 겹친 구간에서 논의된 주제 목록 (최대 5개)

            4. 각 화자 주장의 일관성 평가:
               - 1-5 척도로 평가 (1: 매우 비일관적, 5: 매우 일관적)
               - A의 일관성 점수와 근거
               - B의 일관성 점수와 근거

            5. 각 화자의 사실 관계 정확성:
               - 1-5 척도로 평가 (1: 매우 부정확, 5: 매우 정확)
               - A의 정확성 점수와 근거
               - B의 정확성 점수와 근거

            6. 감정 분석:
               - 각 화자가 사용한 긍정적 단어 비율과 부정적 단어 비율
               - 예시 단어 포함

            7. 각 화자별 잘못 사용한 단어 또는 표현 횟수와 예시

            결과는 반드시 다음과 같은 JSON 형식으로 제공해주세요:

            {
              "speakingTime": {
                "speakerA": 숫자(분),
                "speakerB": 숫자(분)
              },
              "overlaps": {
                "count": 숫자,
                "totalDuration": 숫자(초)
              },
              "overlapTopics": ["주제1 설명", "주제2 설명", ...],
              "consistency": {
                "speakerA": {
                  "score": 숫자(1-5),
                  "reasoning": "설명"
                },
                "speakerB": {
                  "score": 숫자(1-5),
                  "reasoning": "설명"
                }
              },
              "factualAccuracy": {
                "speakerA": {
                  "score": 숫자(1-5),
                  "reasoning": "설명"
                },
                "speakerB": {
                  "score": 숫자(1-5),
                  "reasoning": "설명"
                }
              },
              "sentimentAnalysis": {
                "speakerA": {
                  "positiveRatio": 숫자(0-1),
                  "negativeRatio": 숫자(0-1),
                  "positiveExamples": ["단어1", "단어2", ...],
                  "negativeExamples": ["단어1", "단어2", ...]
                },
                "speakerB": {
                  "positiveRatio": 1 - speakerA의 positiveRatio,
                  "negativeRatio": 1 - speakerA의 negativeRatio,
                  "positiveExamples": ["단어1", "단어2", ...],
                  "negativeExamples": ["단어1", "단어2", ...]
                }
              },
              "incorrectUsage": {
                "speakerA": {
                  "count": 숫자,
                  "examples": ["예시1", "예시2", ...]
                },
                "speakerB": {
                  "count": 숫자,
                  "examples": ["예시1", "예시2", ...]
                }
              }
            }

            정확한 정량적 수치를 제공하고, 모든 비율은 소수점으로 표현하세요(예: 0.75).
            점수는 반드시 1-5 사이의 정수여야 합니다.
            잘못된 단어 사용 예시는 실제 트랜스크립트에서 발견된 사례만 포함해야 합니다.
            positiveRatio와 negativeRatio는 speakerA와 speakerB를 합쳤을 때 1이어야합니다.

            {format_instructions}
            """
    
    static let sampleTranscript = """
    {
      "jobName": "intense-inlaw-argument-transcription",
      "results": {
        "items": [
          {
            "start_time": 0.0,
            "end_time": 4.1,
            "alternatives": [
              {
                "confidence": 0.97,
                "content": "오늘 엄마한테 전화 왔었는데, 이번 추석에 우리 집에 부모님 모시고 싶대. 작년에도 시댁 갔으니까."
              }
            ],
            "speaker_label": "spk_0"
          },
          {
            "start_time": 3.8,
            "end_time": 7.6,
            "alternatives": [
              {
                "confidence": 0.94,
                "content": "또? 설날도 너희 집 갔잖아! 매번 너희 부모님만 신경 쓰고 내 부모님은 무시하냐?"
              }
            ],
            "speaker_label": "spk_1"
          },
          {
            "start_time": 7.3,
            "end_time": 12.4,
            "alternatives": [
              {
                "confidence": 0.95,
                "content": "무슨 무시야? 공평하게 나누는 거지! 근데 너는 항상 니네 부모님만 중요하게 생각하잖아!"
              }
            ],
            "speaker_label": "spk_0"
          },
          {
            "start_time": 12.0,
            "end_time": 17.2,
            "alternatives": [
              {
                "confidence": 0.92,
                "content": "헛소리 하지 마! 네 부모님 오실 때마다 내가 얼마나 공들여서 준비하는데! 근데 너는 우리 부모님께 인사도 제대로 안 해!"
              }
            ],
            "speaker_label": "spk_1"
          },
          {
            "start_time": 16.9,
            "end_time": 22.5,
            "alternatives": [
              {
                "confidence": 0.96,
                "content": "뭐? 내가 언제 인사 안 했어? 오히려 네가 우리 부모님 오시면 늘 피곤하다며 방에만 처박혀 있잖아! 얼굴도 제대로 안 비추고!"
              }
            ],
            "speaker_label": "spk_0"
          },
          {
            "start_time": 22.0,
            "end_time": 27.8,
            "alternatives": [
              {
                "confidence": 0.93,
                "content": "그건 내가 일이 바빠서 그런 거잖아! 넌 매번 이런 식으로 트집 잡더니 이제는 아예 명절까지 뺏으려고? 정말 참을 수가 없네!"
              }
            ],
            "speaker_label": "spk_1"
          },
          {
            "start_time": 27.4,
            "end_time": 33.6,
            "alternatives": [
              {
                "confidence": 0.97,
                "content": "뺏어? 내 부모님도 당신 부모님만큼 소중해! 근데 당신은 항상 당신 부모님만 우선시하잖아! 작년엔 시댁 행사 때문에 우리 아버지 생신도 못 갔어!"
              }
            ],
            "speaker_label": "spk_0"
          },
          {
            "start_time": 33.2,
            "end_time": 39.7,
            "alternatives": [
              {
                "confidence": 0.91,
                "content": "그건 어쩔 수 없었던 거잖아! 우리 아버지 환갑이었어! 근데 너는 내 형제들 모임에도 매번 안 나오려고 하면서!"
              }
            ],
            "speaker_label": "spk_1"
          },
          {
            "start_time": 39.3,
            "end_time": 45.8,
            "alternatives": [
              {
                "confidence": 0.95,
                "content": "내가 언제 안 나갔어? 매번 가면서도 너랑 싸웠잖아! 솔직히 말해봐, 당신 가족들 앞에선 나한테 신경도 안 쓰면서 왜 데려가려고 하는 건데?"
              }
            ],
            "speaker_label": "spk_0"
          },
          {
            "start_time": 45.5,
            "end_time": 52.1,
            "alternatives": [
              {
                "confidence": 0.94,
                "content": "그게 무슨 말도 안 되는 소리야! 내가 언제 신경 안 썼어? 오히려 너는 내 앞에서 부모님한테 전화해서 나 없는 것처럼 얘기하잖아!"
              }
            ],
            "speaker_label": "spk_1"
          },
          {
            "start_time": 51.8,
            "end_time": 58.4,
            "alternatives": [
              {
                "confidence": 0.98,
                "content": "이제 나한테 그런 식으로 말하지 마! 당신은 결혼하고 내 입장은 단 한 번도 생각해본 적 없잖아! 솔직히 당신네 가족 모임 가는 게 얼마나 스트레스인지 알아?"
              }
            ],
            "speaker_label": "spk_0"
          },
          {
            "start_time": 58.0,
            "end_time": 64.3,
            "alternatives": [
              {
                "confidence": 0.96,
                "content": "그래, 그렇게 싫으면 이번엔 아예 오지 마! 나 혼자 갈게! 어차피 너 있으나 없으나 분위기만 어색해지니까!"
              }
            ],
            "speaker_label": "spk_1"
          },
          {
            "start_time": 63.9,
            "end_time": 70.5,
            "alternatives": [
              {
                "confidence": 0.97,
                "content": "뭐? 지금 진심으로 하는 말이야? 결혼해서 이렇게 서로 가족을 무시하면서 살아야 하는 거야? 정말 이렇게 살 거면 우리 그냥..."
              }
            ],
            "speaker_label": "spk_0"
          },
          {
            "start_time": 70.1,
            "end_time": 74.8,
            "alternatives": [
              {
                "confidence": 0.95,
                "content": "그냥 뭐? 말해봐! 이혼이라도 하겠다고? 그렇게 쉽게 말할 수 있어?"
              }
            ],
            "speaker_label": "spk_1"
          },
          {
            "start_time": 74.4,
            "end_time": 79.6,
            "alternatives": [
              {
                "confidence": 0.97,
                "content": "내가 언제 그런 말 했어! 근데 이렇게 서로 상처만 주면서 사는 게 맞는 거냐고! 나 정말 지쳤어!"
              }
            ],
            "speaker_label": "spk_0"
          }
        ],
        "speaker_labels": {
          "speakers": 2,
          "segments": [
            {
              "start_time": 0.0,
              "end_time": 4.1,
              "speaker_label": "spk_0"
            },
            {
              "start_time": 3.8,
              "end_time": 7.6,
              "speaker_label": "spk_1"
            },
            {
              "start_time": 7.3,
              "end_time": 12.4,
              "speaker_label": "spk_0"
            },
            {
              "start_time": 12.0,
              "end_time": 17.2,
              "speaker_label": "spk_1"
            },
            {
              "start_time": 16.9,
              "end_time": 22.5,
              "speaker_label": "spk_0"
            },
            {
              "start_time": 22.0,
              "end_time": 27.8,
              "speaker_label": "spk_1"
            },
            {
              "start_time": 27.4,
              "end_time": 33.6,
              "speaker_label": "spk_0"
            },
            {
              "start_time": 33.2,
              "end_time": 39.7,
              "speaker_label": "spk_1"
            },
            {
              "start_time": 39.3,
              "end_time": 45.8,
              "speaker_label": "spk_0"
            },
            {
              "start_time": 45.5,
              "end_time": 52.1,
              "speaker_label": "spk_1"
            },
            {
              "start_time": 51.8,
              "end_time": 58.4,
              "speaker_label": "spk_0"
            },
            {
              "start_time": 58.0,
              "end_time": 64.3,
              "speaker_label": "spk_1"
            },
            {
              "start_time": 63.9,
              "end_time": 70.5,
              "speaker_label": "spk_0"
            },
            {
              "start_time": 70.1,
              "end_time": 74.8,
              "speaker_label": "spk_1"
            },
            {
              "start_time": 74.4,
              "end_time": 79.6,
              "speaker_label": "spk_0"
            }
          ]
        }
      }
    }
    """
}
