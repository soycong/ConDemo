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
            
            2. 각 화자 주장의 일관성 평가:
               - 1-5 척도로 평가 (1: 매우 비일관적, 5: 매우 일관적)
               - A의 일관성 점수와 근거
               - B의 일관성 점수와 근거
            
            3. 각 화자의 사실 관계 정확성:
               - 1-5 척도로 평가 (1: 매우 부정확, 5: 매우 정확)
               - A의 정확성 점수와 근거
               - B의 정확성 점수와 근거
            
            4. 감정 분석:
               - 각 화자가 사용한 긍정적 단어 비율과 부정적 단어 비율
               - 예시 단어 포함
                        
            결과는 반드시 다음과 같은 JSON 형식으로 제공해주세요:
            
            {
            "speakingTime": {
                "speakerA": 숫자(분),
                "speakerB": 숫자(분)
              },
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
              }
            }
            
            정확한 정량적 수치를 제공하고, 모든 비율은 소수점으로 표현하세요(예: 0.75).
            점수는 반드시 1-5 사이의 정수여야 합니다.
            잘못된 단어 사용 예시는 실제 트랜스크립트에서 발견된 사례만 포함해야 합니다.
            positiveRatio와 negativeRatio는 speakerA와 speakerB를 합쳤을 때 1이어야합니다.
            
            {format_instructions}
            """
    
    static let newholeTemplate = """
    두 사람 간의 대화 내용을 분석해 커뮤니티 콘텐츠로 변환해주세요.
    두 사람은 부부이며, 싸우는 대화 내용입니다.
    타인이 봤을 때 흥미를 유발하는 내용을 생성하는 것이 핵심입니다.
    다음은 분석할 AWS Transcribe JSON 결과입니다:
            
    {transcript}
            
    다음 항목들에 대해 정확하고 정량적인, JSON 형식의 분석 결과를 제공해주세요:
    {
      "title": "대화 주제 요약(한글 10자 이내)",
      "contents": "대화의 주요 쟁점 매력적이고 재미있게 이모지를 섞어서 작성, 최소 200자 이상",
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
          "title": "나의 입장에서(1인칭) 바라본 자극적이고 매력적인 제목",
          "contents": "나의 입장에서 커뮤니티 게시글 스타일의 논쟁(250자 이내)",
          "isCurrentUser": true
        },
        {
          "title": "상대방의 입장에서(1인칭) 바라본 자극적이고 매력적인 제목",
          "contents": "상대방의 입장에서 커뮤니티 게시글 스타일의 논쟁(250자 이내)",
          "isCurrentUser": false
        }
      ],
      "detailedTranscriptAnalysisData": {
        "speakingTime": {
          "speakerA": 숫자(분),
          "speakerB": 숫자(분)
        },
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
        }
      }
    }

    정확한 정량적 수치를 제공하고, 모든 비율은 소수점으로 표현하세요(예: 0.75).
    점수는 반드시 1-5 사이의 정수여야 합니다.
    잘못된 단어 사용 예시는 실제 트랜스크립트에서 발견된 사례만 포함해야 합니다.
    positiveRatio와 negativeRatio는 speakerA와 speakerB를 합쳤을 때 1이어야합니다.

    {format_instructions}

    세부 지침:
    1️⃣ 대화 분석:
       - 제목은 한글로 10자 이내로 핵심을 담아 작성
       - 주요 쟁점(contents) 3가지를 이모지와 함께 흥미롭게 작성 (최소 200자 이상)
       - 싸움의 격한 정도는 대화 톤과 내용에 따라 1~10 사이 숫자로 표현(대화가 없거나 온화한 경우 1)

    2️⃣ 투표(Poll) 생성:
       - 각 쟁점별로 정확히 하나씩, 총 3개의 poll 생성
       - 각 poll 제목은 유저의 호기심을 자극하고 클릭을 유도하는 스타일로 작성
       - 각 poll 옵션은 정확히 4개씩 생성하며, 공감되는 재미있는 선택지로 구성
       - 모든 옵션은 구어체로 작성하여 친근하고 선택하고 싶게 만들기

    3️⃣ 커뮤니티 요약:
       - 두 개의 요약을 생성: 나의 입장과 상대방의 입장 각각에서 본 내용
       - 각 요약의 제목은 SNS에서 공유하고 싶을 정도로 자극적이게 작성
       - 각 요약은 한 사람의 관점에서만 서술하여 주관적인 의견이 드러나도록 구성
       - 실제 커뮤니티 게시물처럼 공감과 흥미를 유발하는 스토리텔링 방식으로 작성
       - 대화 내용 중 인용구를 효과적으로 활용해 실제감 부여
       - 분석적 어조가 아닌 대화체로 작성하여 친근감 형성

    4️⃣ 상세 대화 분석:
       1. 두 화자(A, B)가 각각 말한 시간(초 단위):
          - A가 말한 총 시간
          - B가 말한 총 시간
                     
       2. 각 화자 주장의 일관성 평가:
          - 1-5 척도로 평가 (1: 매우 비일관적, 5: 매우 일관적)
          - A의 일관성 점수와 근거
          - B의 일관성 점수와 근거
       
       3. 각 화자의 사실 관계 정확성:
          - 1-5 척도로 평가 (1: 매우 부정확, 5: 매우 정확)
          - A의 정확성 점수와 근거
          - B의 정확성 점수와 근거
       
       4. 감정 분석:
          - 각 화자가 사용한 긍정적 단어 비율과 부정적 단어 비율
          - 예시 단어 포함
     
    응답은 반드시 유효한 JSON 형식이어야 하며, 모든 필드를 포함해야 합니다. 이모지를 적절히 활용하여 각 섹션을 더 매력적으로 만들어주세요.

    {format_instructions}
    """
    
    static let holeTemplate = """
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
      ],
      "detailedTranscriptAnalysisData": {
        "speakingTime": {
          "speakerA": 숫자(second),
          "speakerB": 숫자(second)
        },
        "overlaps": {
          "count": 숫자,
          "totalDuration": 숫자(second)
        },
        "overlapTopics": ["주제1 설명", "주제2 설명", ...],
        "consistency": {
          "speakerA": {
            "score": 숫자(1-5),
            "reasoning": "첫 번째 화자의 일관성에 대한 평가 근거"
          },
          "speakerB": {
            "score": 숫자(1-5),
            "reasoning": "두 번째 화자의 일관성에 대한 평가 근거"
          }
        },
        "factualAccuracy": {
          "speakerA": {
            "score": 숫자(1-5),
            "reasoning": "첫 번째 화자의 사실 정확성에 대한 평가 근거"
          },
          "speakerB": {
            "score": 숫자(1-5),
            "reasoning": "두 번째 화자의 사실 정확성에 대한 평가 근거"
          }
        },
        "sentimentAnalysis": {
          "speakerA": {
            "positiveRatio": 숫자(0-1),
            "negativeRatio": 숫자(0-1),
            "positiveExamples": ["실제 긍정적 발언1", "실제 긍정적 발언2"],
            "negativeExamples": ["실제 부정적 발언1", "실제 부정적 발언2"]
          },
          "speakerB": {
            "positiveRatio": 1 - speakerA의 positiveRatio,
            "negativeRatio": 1 - speakerA의 negativeRatio,
            "positiveExamples": ["실제 긍정적 발언1", "실제 긍정적 발언2"],
            "negativeExamples": ["실제 부정적 발언1", "실제 부정적 발언2"]
          }
        },
        "incorrectUsage": {
          "speakerA": {
            "count": 숫자,
            "examples": ["잘못된 표현 예시1", "잘못된 표현 예시2"]
          },
          "speakerB": {
            "count": 숫자,
            "examples": ["잘못된 표현 예시1", "잘못된 표현 예시2"]
          }
        }
      }
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

    4️⃣ 상세 대화 분석:
       - 잘못된 단어 사용 예시는 실제 트랜스크립트에서 발견된 사례만 포함해야 합니다.
       - 발화 시간: 각 화자의 대화 시간 비율 분석
       - 대화 겹침: 화자 간 말이 겹치는 횟수와 총 지속 시간
       - 겹침 주제: 대화에서 반복적으로 언급되는 주요 주제들
       - 일관성: 각 화자의 주장 일관성 평가(0-5점)와 근거
       - 사실 정확성: 각 화자가 언급한 사실의 정확도 평가(0-5점)와 근거
       - 감정 분석: 각 화자의 실제 긍정/부정적 발언 비율과 실제 발췌
       - 잘못된 표현: 각 화자의 문법적/의미적으로 부적절한 표현 횟수와 예시
       - 정확한 정량적 수치를 제공하고, 모든 비율은 소수점으로 표현하세요(예: 0.75).
       - 점수는 반드시 1-5 사이의 정수여야 합니다.
       - positiveRatio와 negativeRatio는 speakerA와 speakerB를 합쳤을 때 1이어야합니다.

    응답은 반드시 유효한 JSON 형식이어야 하며, 모든 필드를 포함해야 합니다. 이모지를 적절히 활용하여 각 섹션을 더 매력적으로 만들어주세요.

    {format_instructions}
    """
}
