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
    
    static let englishTemplateKoreanResponse = """
    Please analyze the conversation between two people and transform it into community content:
    You are an expert in analyzing conversations from meetings, interviews, debates, etc. Please analyze the dialogue between two speakers (A and B) based on the AWS Transcribe results I provide.
            
    Here is the AWS Transcribe JSON result to analyze:
            
    {transcript}
            
    Please provide an accurate and quantitative analysis in JSON format for the following items, BUT PROVIDE YOUR RESPONSE IN KOREAN:
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
    }

    Provide accurate quantitative values, and express all ratios as decimals (e.g., 0.75).
    Scores must be integers between 1-5.
    Examples of incorrect word usage should only include cases found in the actual transcript.
    The positiveRatio and negativeRatio of speakerA and speakerB should sum to 1.

    {format_instructions}

    Detailed guidelines:
    1️⃣ Conversation Analysis:
       - Title should be in Korean, within 10 characters, capturing the essence
       - Argument intensity level should be a number between 1-10 based on tone and content (1 for mild/no argument)
       - Three main points of contention written in an engaging way with emojis

    2️⃣ Poll Creation:
       - Create exactly one poll for each point of contention, for a total of 3 polls
       - Each poll title should pique user curiosity and encourage clicks
       - Each poll should have exactly 4 options that are relatable and interesting
       - All options should be written in conversational language to create a sense of familiarity

    3️⃣ Community Summaries:
       - Create two summaries: one from my perspective and one from the other person's perspective
       - Each summary title should be provocative and attractive enough to share on social media
       - Each summary should be written from only one person's perspective, showing subjective opinions
       - Write like actual community posts that evoke empathy and interest with a storytelling approach
       - Effectively use quotes from the conversation to add authenticity
       - Use conversational rather than analytical tone to create familiarity

    4️⃣ Detailed Conversation Analysis:
       1. Time spoken by each speaker (A, B) in minutes:
          - Total time spoken by A
          - Total time spoken by B
       
       2. Number of overlaps and total duration of overlaps in seconds
       
       3. List of topics discussed during overlapping speech (maximum 5)
       
       4. Consistency evaluation for each speaker:
          - Rate on a scale of 1-5 (1: very inconsistent, 5: very consistent)
          - Speaker A's consistency score and reasoning
          - Speaker B's consistency score and reasoning
       
       5. Factual accuracy of each speaker:
          - Rate on a scale of 1-5 (1: very inaccurate, 5: very accurate)
          - Speaker A's accuracy score and reasoning
          - Speaker B's accuracy score and reasoning
       
       6. Sentiment analysis:
          - Ratio of positive and negative words used by each speaker
          - Include example words
       
       7. Incorrect word usage count and examples for each speaker
                    
    The response must be in valid JSON format and include all fields. Use emojis appropriately to make each section more attractive.

    Remember to provide your final response in Korean language while maintaining the JSON structure.

    {format_instructions}
    """
    
    static let englishTemplate = """
    Please analyze the conversation between two people and transform it into community content:
    You are an expert in analyzing conversations from meetings, interviews, debates, etc. Please analyze the dialogue between two speakers (A and B) based on the AWS Transcribe results I provide.
            
    Here is the AWS Transcribe JSON result to analyze:
            
    {transcript}
            
    Please provide an accurate and quantitative analysis in JSON format for the following items, BUT PROVIDE YOUR RESPONSE IN KOREAN:
    {
      "title": "Conversation title (within 10 Korean characters)",
      "contents": "Three main points of contention written in an attractive and interesting way",
      "level": "Number between 1-10 (intensity of argument)",
      "polls": [
        {
          "title": "First point of contention title (make it attractive and provocative)",
          "contents": "First point explanation (make it interesting)",
          "myOpinion": "First speaker's opinion (be specific)",
          "yourOpinion": "Second speaker's opinion (be specific)",
          "options": ["Option1", "Option2", "Option3", "Option4"]
        },
        {
          "title": "Second point of contention title (make it attractive and provocative)",
          "contents": "Second point explanation (make it interesting)",
          "myOpinion": "First speaker's opinion (be specific)",
          "yourOpinion": "Second speaker's opinion (be specific)",
          "options": ["Option1", "Option2", "Option3", "Option4"]
        },
        {
          "title": "Third point of contention title (make it attractive and provocative)",
          "contents": "Third point explanation (make it interesting)",
          "myOpinion": "First speaker's opinion (be specific)",
          "yourOpinion": "Second speaker's opinion (be specific)",
          "options": ["Option1", "Option2", "Option3", "Option4"]
        }
      ],
      "summaries": [
        {
          "title": "Provocative and attractive title from my perspective",
          "contents": "Community post-style argument from my perspective (within 250 characters)",
          "isCurrentUser": true
        },
        {
          "title": "Provocative and attractive title from the other person's perspective",
          "contents": "Community post-style argument from the other person's perspective (within 250 characters)",
          "isCurrentUser": false
        }
      ],
      "detailedTranscriptAnalysisData": {
        "speakingTime": {
          "speakerA": "Number (minutes)",
          "speakerB": "Number (minutes)"
        },
        "overlaps": {
          "count": "Number",
          "totalDuration": "Number (seconds)"
        },
        "overlapTopics": ["Topic1 description", "Topic2 description", "..."],
        "consistency": {
          "speakerA": {
            "score": "Number (1-5)",
            "reasoning": "Explanation"
          },
          "speakerB": {
            "score": "Number (1-5)",
            "reasoning": "Explanation"
          }
        },
        "factualAccuracy": {
          "speakerA": {
            "score": "Number (1-5)",
            "reasoning": "Explanation"
          },
          "speakerB": {
            "score": "Number (1-5)",
            "reasoning": "Explanation"
          }
        },
        "sentimentAnalysis": {
          "speakerA": {
            "positiveRatio": "Number (0-1)",
            "negativeRatio": "Number (0-1)",
            "positiveExamples": ["Word1", "Word2", "..."],
            "negativeExamples": ["Word1", "Word2", "..."]
          },
          "speakerB": {
            "positiveRatio": "1 - speakerA's positiveRatio",
            "negativeRatio": "1 - speakerA's negativeRatio",
            "positiveExamples": ["Word1", "Word2", "..."],
            "negativeExamples": ["Word1", "Word2", "..."]
          }
        },
        "incorrectUsage": {
          "speakerA": {
            "count": "Number",
            "examples": ["Example1", "Example2", "..."]
          },
          "speakerB": {
            "count": "Number",
            "examples": ["Example1", "Example2", "..."]
          }
        }
      }
    }

    Provide accurate quantitative values, and express all ratios as decimals (e.g., 0.75).
    Scores must be integers between 1-5.
    Examples of incorrect word usage should only include cases found in the actual transcript.
    The positiveRatio and negativeRatio of speakerA and speakerB should sum to 1.
    
    {format_instructions}

    Detailed guidelines:
    1️⃣ Conversation Analysis:
       - Title should be in Korean, within 10 characters, capturing the essence
       - Argument intensity level should be a number between 1-10 based on tone and content (1 for mild/no argument)
       - Three main points of contention written in an engaging way with emojis

    2️⃣ Poll Creation:
       - Create exactly one poll for each point of contention, for a total of 3 polls
       - Each poll title should pique user curiosity and encourage clicks
       - Each poll should have exactly 4 options that are relatable and interesting
       - All options should be written in conversational language to create a sense of familiarity

    3️⃣ Community Summaries:
       - Create two summaries: one from my perspective and one from the other person's perspective
       - Each summary title should be provocative and attractive enough to share on social media
       - Each summary should be written from only one person's perspective, showing subjective opinions
       - Write like actual community posts that evoke empathy and interest with a storytelling approach
       - Effectively use quotes from the conversation to add authenticity
       - Use conversational rather than analytical tone to create familiarity

    4️⃣ Detailed Conversation Analysis:
       1. Time spoken by each speaker (A, B) in minutes:
          - Total time spoken by A
          - Total time spoken by B
       
       2. Number of overlaps and total duration of overlaps in seconds
       
       3. List of topics discussed during overlapping speech (maximum 5)
       
       4. Consistency evaluation for each speaker:
          - Rate on a scale of 1-5 (1: very inconsistent, 5: very consistent)
          - Speaker A's consistency score and reasoning
          - Speaker B's consistency score and reasoning
       
       5. Factual accuracy of each speaker:
          - Rate on a scale of 1-5 (1: very inaccurate, 5: very accurate)
          - Speaker A's accuracy score and reasoning
          - Speaker B's accuracy score and reasoning
       
       6. Sentiment analysis:
          - Ratio of positive and negative words used by each speaker
          - Include example words
       
       7. Incorrect word usage count and examples for each speaker
                    
    The response must be in valid JSON format and include all fields. Use emojis appropriately to make each section more attractive.

    Remember to provide your final response in Korean language while maintaining the JSON structure.

    {format_instructions}
    """
    
    static let newholeTemplate = """
    다음 두 사람 간의 대화 내용을 분석해 커뮤니티 콘텐츠로 변환해주세요:
    당신은 회의, 인터뷰, 토론 등의 대화 내용을 심층 분석하는 전문가입니다. 제가 제공하는 AWS Transcribe 결과를 바탕으로 두 화자(A와 B)의 대화를 분석해주세요.
            
    다음은 분석할 AWS Transcribe JSON 결과입니다:
            
    {transcript}
            
    다음 항목들에 대해 정확하고 정량적인, JSON 형식의 분석 결과를 제공해주세요:
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
    
    static let sampleTranscript = """
    {"jobName":"transcription-job-AB4438F9-7D5B-43FB-BDAF-769B6C989EC0","accountId":"281987066515","status":"COMPLETED","results":{"transcripts":[{"transcript":"아 영상 좀 그만 봐. 아, 이거 내가 하루 스트레스 푸는 거 아니야. 또. 맨날 피곤하다. 왜 또 그래? 지금 새벽 두 시잖아, 지금. 아 내가 이걸로 좀 뭐라 하지 말아달라고 그랬잖아. 내가 이거 오늘 하루 내가 이거 피로 겨우 푸는 건데 이걸로 뭐라 그래? 아니 근데 영상을 보고 싶으면 다음날 그냥 피곤하다고 하지 말던가. 아 피곤할 수 있지. 근데 이것 이것조차 안 하면 내가 더 피곤하니까 해서 그래. 아 무슨 소리. 잠을 자야 안 피곤하지. 이게 무슨 말이야, 이게 도대체? 아이 아이 아이 아이 아이 아이 아니 아니 아니 아니 아니 아니 아니 아니 아니 아니"}],"speaker_labels":{"segments":[{"start_time":"0.56","end_time":"1.559","speaker_label":"spk_0","items":[{"speaker_label":"spk_0","start_time":"0.589","end_time":"0.87"},{"speaker_label":"spk_0","start_time":"0.87","end_time":"1.12"},{"speaker_label":"spk_0","start_time":"1.12","end_time":"1.32"},{"speaker_label":"spk_0","start_time":"1.32","end_time":"1.559"}]},{"start_time":"1.559","end_time":"15.539","speaker_label":"spk_1","items":[{"speaker_label":"spk_1","start_time":"1.559","end_time":"1.919"},{"speaker_label":"spk_1","start_time":"2.329","end_time":"2.549"},{"speaker_label":"spk_1","start_time":"2.559","end_time":"2.72"},{"speaker_label":"spk_1","start_time":"2.72","end_time":"2.96"},{"speaker_label":"spk_1","start_time":"2.96","end_time":"3.15"},{"speaker_label":"spk_1","start_time":"3.15","end_time":"3.549"},{"speaker_label":"spk_1","start_time":"3.549","end_time":"3.839"},{"speaker_label":"spk_1","start_time":"3.839","end_time":"4.03"},{"speaker_label":"spk_1","start_time":"4.03","end_time":"4.19"},{"speaker_label":"spk_1","start_time":"4.199","end_time":"4.329"},{"speaker_label":"spk_1","start_time":"4.679","end_time":"5.15"},{"speaker_label":"spk_1","start_time":"5.15","end_time":"5.519"},{"speaker_label":"spk_1","start_time":"6.409","end_time":"6.619"},{"speaker_label":"spk_1","start_time":"6.619","end_time":"6.769"},{"speaker_label":"spk_1","start_time":"6.769","end_time":"7.309"},{"speaker_label":"spk_1","start_time":"7.48","end_time":"7.639"},{"speaker_label":"spk_1","start_time":"7.639","end_time":"8.0"},{"speaker_label":"spk_1","start_time":"8.0","end_time":"8.189"},{"speaker_label":"spk_1","start_time":"8.189","end_time":"8.67"},{"speaker_label":"spk_1","start_time":"8.75","end_time":"9.329"},{"speaker_label":"spk_1","start_time":"9.609","end_time":"9.63"},{"speaker_label":"spk_1","start_time":"9.63","end_time":"9.939"},{"speaker_label":"spk_1","start_time":"9.939","end_time":"10.109"},{"speaker_label":"spk_1","start_time":"10.109","end_time":"10.25"},{"speaker_label":"spk_1","start_time":"10.25","end_time":"10.43"},{"speaker_label":"spk_1","start_time":"10.43","end_time":"10.67"},{"speaker_label":"spk_1","start_time":"10.67","end_time":"11.35"},{"speaker_label":"spk_1","start_time":"11.35","end_time":"11.77"},{"speaker_label":"spk_1","start_time":"11.829","end_time":"12.17"},{"speaker_label":"spk_1","start_time":"12.17","end_time":"12.51"},{"speaker_label":"spk_1","start_time":"12.81","end_time":"13.079"},{"speaker_label":"spk_1","start_time":"13.079","end_time":"13.319"},{"speaker_label":"spk_1","start_time":"13.319","end_time":"13.8"},{"speaker_label":"spk_1","start_time":"13.8","end_time":"13.84"},{"speaker_label":"spk_1","start_time":"13.84","end_time":"14.029"},{"speaker_label":"spk_1","start_time":"14.029","end_time":"14.31"},{"speaker_label":"spk_1","start_time":"14.31","end_time":"14.569"},{"speaker_label":"spk_1","start_time":"14.569","end_time":"14.989"},{"speaker_label":"spk_1","start_time":"14.989","end_time":"15.229"},{"speaker_label":"spk_1","start_time":"15.229","end_time":"15.439"},{"speaker_label":"spk_1","start_time":"15.439","end_time":"15.539"}]},{"start_time":"15.88","end_time":"19.87","speaker_label":"spk_0","items":[{"speaker_label":"spk_0","start_time":"15.88","end_time":"16.12"},{"speaker_label":"spk_0","start_time":"16.12","end_time":"16.309"},{"speaker_label":"spk_0","start_time":"16.309","end_time":"16.809"},{"speaker_label":"spk_0","start_time":"16.809","end_time":"17.0"},{"speaker_label":"spk_0","start_time":"17.0","end_time":"17.79"},{"speaker_label":"spk_0","start_time":"17.79","end_time":"18.159"},{"speaker_label":"spk_0","start_time":"18.159","end_time":"18.319"},{"speaker_label":"spk_0","start_time":"18.319","end_time":"18.879"},{"speaker_label":"spk_0","start_time":"18.879","end_time":"19.2"},{"speaker_label":"spk_0","start_time":"19.2","end_time":"19.87"}]},{"start_time":"20.52","end_time":"25.559","speaker_label":"spk_1","items":[{"speaker_label":"spk_1","start_time":"20.52","end_time":"20.79"},{"speaker_label":"spk_1","start_time":"20.79","end_time":"21.12"},{"speaker_label":"spk_1","start_time":"21.12","end_time":"21.29"},{"speaker_label":"spk_1","start_time":"21.29","end_time":"21.6"},{"speaker_label":"spk_1","start_time":"21.67","end_time":"22.149"},{"speaker_label":"spk_1","start_time":"22.52","end_time":"22.95"},{"speaker_label":"spk_1","start_time":"22.95","end_time":"23.459"},{"speaker_label":"spk_1","start_time":"23.459","end_time":"23.6"},{"speaker_label":"spk_1","start_time":"23.6","end_time":"23.78"},{"speaker_label":"spk_1","start_time":"23.78","end_time":"24.04"},{"speaker_label":"spk_1","start_time":"24.04","end_time":"24.239"},{"speaker_label":"spk_1","start_time":"24.239","end_time":"24.86"},{"speaker_label":"spk_1","start_time":"24.86","end_time":"24.979"},{"speaker_label":"spk_1","start_time":"24.979","end_time":"25.27"},{"speaker_label":"spk_1","start_time":"25.479","end_time":"25.559"}]},{"start_time":"25.559","end_time":"28.52","speaker_label":"spk_0","items":[{"speaker_label":"spk_0","start_time":"25.559","end_time":"25.799"},{"speaker_label":"spk_0","start_time":"25.799","end_time":"26.049"},{"speaker_label":"spk_0","start_time":"26.11","end_time":"26.549"},{"speaker_label":"spk_0","start_time":"26.549","end_time":"26.799"},{"speaker_label":"spk_0","start_time":"26.799","end_time":"26.979"},{"speaker_label":"spk_0","start_time":"26.979","end_time":"27.399"},{"speaker_label":"spk_0","start_time":"27.54","end_time":"27.68"},{"speaker_label":"spk_0","start_time":"27.68","end_time":"27.989"},{"speaker_label":"spk_0","start_time":"27.989","end_time":"28.36"},{"speaker_label":"spk_0","start_time":"28.37","end_time":"28.52"}]},{"start_time":"28.52","end_time":"29.25","speaker_label":"spk_1","items":[{"speaker_label":"spk_1","start_time":"28.52","end_time":"28.989"}]},{"start_time":"29.899","end_time":"30.26","speaker_label":"spk_1","items":[{"speaker_label":"spk_1","start_time":"29.909","end_time":"29.92"},{"speaker_label":"spk_1","start_time":"29.93","end_time":"29.94"},{"speaker_label":"spk_1","start_time":"29.969","end_time":"29.979"},{"speaker_label":"spk_1","start_time":"29.989","end_time":"30.0"},{"speaker_label":"spk_1","start_time":"30.01","end_time":"30.02"},{"speaker_label":"spk_1","start_time":"30.03","end_time":"30.04"},{"speaker_label":"spk_1","start_time":"30.04","end_time":"30.049"},{"speaker_label":"spk_1","start_time":"30.059","end_time":"30.069"},{"speaker_label":"spk_1","start_time":"30.079","end_time":"30.09"},{"speaker_label":"spk_1","start_time":"30.1","end_time":"30.11"},{"speaker_label":"spk_1","start_time":"30.12","end_time":"30.129"},{"speaker_label":"spk_1","start_time":"30.139","end_time":"30.149"},{"speaker_label":"spk_1","start_time":"30.159","end_time":"30.17"},{"speaker_label":"spk_1","start_time":"30.18","end_time":"30.19"},{"speaker_label":"spk_1","start_time":"30.2","end_time":"30.209"},{"speaker_label":"spk_1","start_time":"30.219","end_time":"30.229"}]}],"channel_label":"ch_0","speakers":2},"items":[{"id":0,"type":"pronunciation","alternatives":[{"confidence":"0.818","content":"아"}],"start_time":"0.589","end_time":"0.87","speaker_label":"spk_0"},{"id":1,"type":"pronunciation","alternatives":[{"confidence":"0.865","content":"영상"}],"start_time":"0.87","end_time":"1.12","speaker_label":"spk_0"},{"id":2,"type":"pronunciation","alternatives":[{"confidence":"0.853","content":"좀"}],"start_time":"1.12","end_time":"1.32","speaker_label":"spk_0"},{"id":3,"type":"pronunciation","alternatives":[{"confidence":"0.798","content":"그만"}],"start_time":"1.32","end_time":"1.559","speaker_label":"spk_0"},{"id":4,"type":"pronunciation","alternatives":[{"confidence":"0.86","content":"봐"}],"start_time":"1.559","end_time":"1.919","speaker_label":"spk_1"},{"id":5,"type":"punctuation","alternatives":[{"confidence":"0.0","content":"."}],"speaker_label":"spk_1"},{"id":6,"type":"pronunciation","alternatives":[{"confidence":"0.819","content":"아"}],"start_time":"2.329","end_time":"2.549","speaker_label":"spk_1"},{"id":7,"type":"punctuation","alternatives":[{"confidence":"0.0","content":","}],"speaker_label":"spk_1"},{"id":8,"type":"pronunciation","alternatives":[{"confidence":"0.965","content":"이거"}],"start_time":"2.559","end_time":"2.72","speaker_label":"spk_1"},{"id":9,"type":"pronunciation","alternatives":[{"confidence":"0.901","content":"내가"}],"start_time":"2.72","end_time":"2.96","speaker_label":"spk_1"},{"id":10,"type":"pronunciation","alternatives":[{"confidence":"0.993","content":"하루"}],"start_time":"2.96","end_time":"3.15","speaker_label":"spk_1"},{"id":11,"type":"pronunciation","alternatives":[{"confidence":"0.973","content":"스트레스"}],"start_time":"3.15","end_time":"3.549","speaker_label":"spk_1"},{"id":12,"type":"pronunciation","alternatives":[{"confidence":"0.958","content":"푸는"}],"start_time":"3.549","end_time":"3.839","speaker_label":"spk_1"},{"id":13,"type":"pronunciation","alternatives":[{"confidence":"0.9","content":"거"}],"start_time":"3.839","end_time":"4.03","speaker_label":"spk_1"},{"id":14,"type":"pronunciation","alternatives":[{"confidence":"0.781","content":"아니야"}],"start_time":"4.03","end_time":"4.19","speaker_label":"spk_1"},{"id":15,"type":"punctuation","alternatives":[{"confidence":"0.0","content":"."}],"speaker_label":"spk_1"},{"id":16,"type":"pronunciation","alternatives":[{"confidence":"0.784","content":"또"}],"start_time":"4.199","end_time":"4.329","speaker_label":"spk_1"},{"id":17,"type":"punctuation","alternatives":[{"confidence":"0.0","content":"."}],"speaker_label":"spk_1"},{"id":18,"type":"pronunciation","alternatives":[{"confidence":"0.51","content":"맨날"}],"start_time":"4.679","end_time":"5.15","speaker_label":"spk_1"},{"id":19,"type":"pronunciation","alternatives":[{"confidence":"0.87","content":"피곤하다"}],"start_time":"5.15","end_time":"5.519","speaker_label":"spk_1"},{"id":20,"type":"punctuation","alternatives":[{"confidence":"0.0","content":"."}],"speaker_label":"spk_1"},{"id":21,"type":"pronunciation","alternatives":[{"confidence":"0.993","content":"왜"}],"start_time":"6.409","end_time":"6.619","speaker_label":"spk_1"},{"id":22,"type":"pronunciation","alternatives":[{"confidence":"0.982","content":"또"}],"start_time":"6.619","end_time":"6.769","speaker_label":"spk_1"},{"id":23,"type":"pronunciation","alternatives":[{"confidence":"0.987","content":"그래"}],"start_time":"6.769","end_time":"7.309","speaker_label":"spk_1"},{"id":24,"type":"punctuation","alternatives":[{"confidence":"0.0","content":"?"}],"speaker_label":"spk_1"},{"id":25,"type":"pronunciation","alternatives":[{"confidence":"0.882","content":"지금"}],"start_time":"7.48","end_time":"7.639","speaker_label":"spk_1"},{"id":26,"type":"pronunciation","alternatives":[{"confidence":"0.873","content":"새벽"}],"start_time":"7.639","end_time":"8.0","speaker_label":"spk_1"},{"id":27,"type":"pronunciation","alternatives":[{"confidence":"0.982","content":"두"}],"start_time":"8.0","end_time":"8.189","speaker_label":"spk_1"},{"id":28,"type":"pronunciation","alternatives":[{"confidence":"0.862","content":"시잖아"}],"start_time":"8.189","end_time":"8.67","speaker_label":"spk_1"},{"id":29,"type":"punctuation","alternatives":[{"confidence":"0.0","content":","}],"speaker_label":"spk_1"},{"id":30,"type":"pronunciation","alternatives":[{"confidence":"0.944","content":"지금"}],"start_time":"8.75","end_time":"9.329","speaker_label":"spk_1"},{"id":31,"type":"punctuation","alternatives":[{"confidence":"0.0","content":"."}],"speaker_label":"spk_1"},{"id":32,"type":"pronunciation","alternatives":[{"confidence":"0.438","content":"아"}],"start_time":"9.609","end_time":"9.63","speaker_label":"spk_1"},{"id":33,"type":"pronunciation","alternatives":[{"confidence":"0.904","content":"내가"}],"start_time":"9.63","end_time":"9.939","speaker_label":"spk_1"},{"id":34,"type":"pronunciation","alternatives":[{"confidence":"0.793","content":"이걸로"}],"start_time":"9.939","end_time":"10.109","speaker_label":"spk_1"},{"id":35,"type":"pronunciation","alternatives":[{"confidence":"0.874","content":"좀"}],"start_time":"10.109","end_time":"10.25","speaker_label":"spk_1"},{"id":36,"type":"pronunciation","alternatives":[{"confidence":"0.913","content":"뭐라"}],"start_time":"10.25","end_time":"10.43","speaker_label":"spk_1"},{"id":37,"type":"pronunciation","alternatives":[{"confidence":"0.929","content":"하지"}],"start_time":"10.43","end_time":"10.67","speaker_label":"spk_1"},{"id":38,"type":"pronunciation","alternatives":[{"confidence":"0.37","content":"말아달라고"}],"start_time":"10.67","end_time":"11.35","speaker_label":"spk_1"},{"id":39,"type":"pronunciation","alternatives":[{"confidence":"0.98","content":"그랬잖아"}],"start_time":"11.35","end_time":"11.77","speaker_label":"spk_1"},{"id":40,"type":"punctuation","alternatives":[{"confidence":"0.0","content":"."}],"speaker_label":"spk_1"},{"id":41,"type":"pronunciation","alternatives":[{"confidence":"0.99","content":"내가"}],"start_time":"11.829","end_time":"12.17","speaker_label":"spk_1"},{"id":42,"type":"pronunciation","alternatives":[{"confidence":"0.988","content":"이거"}],"start_time":"12.17","end_time":"12.51","speaker_label":"spk_1"},{"id":43,"type":"pronunciation","alternatives":[{"confidence":"0.994","content":"오늘"}],"start_time":"12.81","end_time":"13.079","speaker_label":"spk_1"},{"id":44,"type":"pronunciation","alternatives":[{"confidence":"0.996","content":"하루"}],"start_time":"13.079","end_time":"13.319","speaker_label":"spk_1"},{"id":45,"type":"pronunciation","alternatives":[{"confidence":"0.987","content":"내가"}],"start_time":"13.319","end_time":"13.8","speaker_label":"spk_1"},{"id":46,"type":"pronunciation","alternatives":[{"confidence":"0.946","content":"이거"}],"start_time":"13.8","end_time":"13.84","speaker_label":"spk_1"},{"id":47,"type":"pronunciation","alternatives":[{"confidence":"0.942","content":"피로"}],"start_time":"13.84","end_time":"14.029","speaker_label":"spk_1"},{"id":48,"type":"pronunciation","alternatives":[{"confidence":"0.95","content":"겨우"}],"start_time":"14.029","end_time":"14.31","speaker_label":"spk_1"},{"id":49,"type":"pronunciation","alternatives":[{"confidence":"0.964","content":"푸는"}],"start_time":"14.31","end_time":"14.569","speaker_label":"spk_1"},{"id":50,"type":"pronunciation","alternatives":[{"confidence":"0.901","content":"건데"}],"start_time":"14.569","end_time":"14.989","speaker_label":"spk_1"},{"id":51,"type":"pronunciation","alternatives":[{"confidence":"0.935","content":"이걸로"}],"start_time":"14.989","end_time":"15.229","speaker_label":"spk_1"},{"id":52,"type":"pronunciation","alternatives":[{"confidence":"0.651","content":"뭐라"}],"start_time":"15.229","end_time":"15.439","speaker_label":"spk_1"},{"id":53,"type":"pronunciation","alternatives":[{"confidence":"0.938","content":"그래"}],"start_time":"15.439","end_time":"15.539","speaker_label":"spk_1"},{"id":54,"type":"punctuation","alternatives":[{"confidence":"0.0","content":"?"}],"speaker_label":"spk_1"},{"id":55,"type":"pronunciation","alternatives":[{"confidence":"0.878","content":"아니"}],"start_time":"15.88","end_time":"16.12","speaker_label":"spk_0"},{"id":56,"type":"pronunciation","alternatives":[{"confidence":"0.78","content":"근데"}],"start_time":"16.12","end_time":"16.309","speaker_label":"spk_0"},{"id":57,"type":"pronunciation","alternatives":[{"confidence":"0.803","content":"영상을"}],"start_time":"16.309","end_time":"16.809","speaker_label":"spk_0"},{"id":58,"type":"pronunciation","alternatives":[{"confidence":"0.977","content":"보고"}],"start_time":"16.809","end_time":"17.0","speaker_label":"spk_0"},{"id":59,"type":"pronunciation","alternatives":[{"confidence":"0.85","content":"싶으면"}],"start_time":"17.0","end_time":"17.79","speaker_label":"spk_0"},{"id":60,"type":"pronunciation","alternatives":[{"confidence":"0.78","content":"다음날"}],"start_time":"17.79","end_time":"18.159","speaker_label":"spk_0"},{"id":61,"type":"pronunciation","alternatives":[{"confidence":"0.719","content":"그냥"}],"start_time":"18.159","end_time":"18.319","speaker_label":"spk_0"},{"id":62,"type":"pronunciation","alternatives":[{"confidence":"0.865","content":"피곤하다고"}],"start_time":"18.319","end_time":"18.879","speaker_label":"spk_0"},{"id":63,"type":"pronunciation","alternatives":[{"confidence":"0.897","content":"하지"}],"start_time":"18.879","end_time":"19.2","speaker_label":"spk_0"},{"id":64,"type":"pronunciation","alternatives":[{"confidence":"0.724","content":"말던가"}],"start_time":"19.2","end_time":"19.87","speaker_label":"spk_0"},{"id":65,"type":"punctuation","alternatives":[{"confidence":"0.0","content":"."}],"speaker_label":"spk_0"},{"id":66,"type":"pronunciation","alternatives":[{"confidence":"0.689","content":"아"}],"start_time":"20.52","end_time":"20.79","speaker_label":"spk_1"},{"id":67,"type":"pronunciation","alternatives":[{"confidence":"0.969","content":"피곤할"}],"start_time":"20.79","end_time":"21.12","speaker_label":"spk_1"},{"id":68,"type":"pronunciation","alternatives":[{"confidence":"0.742","content":"수"}],"start_time":"21.12","end_time":"21.29","speaker_label":"spk_1"},{"id":69,"type":"pronunciation","alternatives":[{"confidence":"0.987","content":"있지"}],"start_time":"21.29","end_time":"21.6","speaker_label":"spk_1"},{"id":70,"type":"punctuation","alternatives":[{"confidence":"0.0","content":"."}],"speaker_label":"spk_1"},{"id":71,"type":"pronunciation","alternatives":[{"confidence":"0.939","content":"근데"}],"start_time":"21.67","end_time":"22.149","speaker_label":"spk_1"},{"id":72,"type":"pronunciation","alternatives":[{"confidence":"0.454","content":"이것"}],"start_time":"22.52","end_time":"22.95","speaker_label":"spk_1"},{"id":73,"type":"pronunciation","alternatives":[{"confidence":"0.782","content":"이것조차"}],"start_time":"22.95","end_time":"23.459","speaker_label":"spk_1"},{"id":74,"type":"pronunciation","alternatives":[{"confidence":"0.994","content":"안"}],"start_time":"23.459","end_time":"23.6","speaker_label":"spk_1"},{"id":75,"type":"pronunciation","alternatives":[{"confidence":"0.869","content":"하면"}],"start_time":"23.6","end_time":"23.78","speaker_label":"spk_1"},{"id":76,"type":"pronunciation","alternatives":[{"confidence":"0.98","content":"내가"}],"start_time":"23.78","end_time":"24.04","speaker_label":"spk_1"},{"id":77,"type":"pronunciation","alternatives":[{"confidence":"0.996","content":"더"}],"start_time":"24.04","end_time":"24.239","speaker_label":"spk_1"},{"id":78,"type":"pronunciation","alternatives":[{"confidence":"0.98","content":"피곤하니까"}],"start_time":"24.239","end_time":"24.86","speaker_label":"spk_1"},{"id":79,"type":"pronunciation","alternatives":[{"confidence":"0.974","content":"해서"}],"start_time":"24.86","end_time":"24.979","speaker_label":"spk_1"},{"id":80,"type":"pronunciation","alternatives":[{"confidence":"0.996","content":"그래"}],"start_time":"24.979","end_time":"25.27","speaker_label":"spk_1"},{"id":81,"type":"punctuation","alternatives":[{"confidence":"0.0","content":"."}],"speaker_label":"spk_1"},{"id":82,"type":"pronunciation","alternatives":[{"confidence":"0.821","content":"아"}],"start_time":"25.479","end_time":"25.559","speaker_label":"spk_1"},{"id":83,"type":"pronunciation","alternatives":[{"confidence":"0.667","content":"무슨"}],"start_time":"25.559","end_time":"25.799","speaker_label":"spk_0"},{"id":84,"type":"pronunciation","alternatives":[{"confidence":"0.431","content":"소리"}],"start_time":"25.799","end_time":"26.049","speaker_label":"spk_0"},{"id":85,"type":"punctuation","alternatives":[{"confidence":"0.0","content":"."}],"speaker_label":"spk_0"},{"id":86,"type":"pronunciation","alternatives":[{"confidence":"0.885","content":"잠을"}],"start_time":"26.11","end_time":"26.549","speaker_label":"spk_0"},{"id":87,"type":"pronunciation","alternatives":[{"confidence":"0.964","content":"자야"}],"start_time":"26.549","end_time":"26.799","speaker_label":"spk_0"},{"id":88,"type":"pronunciation","alternatives":[{"confidence":"0.98","content":"안"}],"start_time":"26.799","end_time":"26.979","speaker_label":"spk_0"},{"id":89,"type":"pronunciation","alternatives":[{"confidence":"0.951","content":"피곤하지"}],"start_time":"26.979","end_time":"27.399","speaker_label":"spk_0"},{"id":90,"type":"punctuation","alternatives":[{"confidence":"0.0","content":"."}],"speaker_label":"spk_0"},{"id":91,"type":"pronunciation","alternatives":[{"confidence":"0.593","content":"이게"}],"start_time":"27.54","end_time":"27.68","speaker_label":"spk_0"},{"id":92,"type":"pronunciation","alternatives":[{"confidence":"0.993","content":"무슨"}],"start_time":"27.68","end_time":"27.989","speaker_label":"spk_0"},{"id":93,"type":"pronunciation","alternatives":[{"confidence":"0.787","content":"말이야"}],"start_time":"27.989","end_time":"28.36","speaker_label":"spk_0"},{"id":94,"type":"punctuation","alternatives":[{"confidence":"0.0","content":","}],"speaker_label":"spk_0"},{"id":95,"type":"pronunciation","alternatives":[{"confidence":"0.956","content":"이게"}],"start_time":"28.37","end_time":"28.52","speaker_label":"spk_0"},{"id":96,"type":"pronunciation","alternatives":[{"confidence":"0.935","content":"도대체"}],"start_time":"28.52","end_time":"28.989","speaker_label":"spk_1"},{"id":97,"type":"punctuation","alternatives":[{"confidence":"0.0","content":"?"}],"speaker_label":"spk_1"},{"id":98,"type":"pronunciation","alternatives":[{"confidence":"0.463","content":"아이"}],"start_time":"29.909","end_time":"29.92","speaker_label":"spk_1"},{"id":99,"type":"pronunciation","alternatives":[{"confidence":"0.54","content":"아이"}],"start_time":"29.93","end_time":"29.94","speaker_label":"spk_1"},{"id":100,"type":"pronunciation","alternatives":[{"confidence":"0.481","content":"아이"}],"start_time":"29.969","end_time":"29.979","speaker_label":"spk_1"},{"id":101,"type":"pronunciation","alternatives":[{"confidence":"0.525","content":"아이"}],"start_time":"29.989","end_time":"30.0","speaker_label":"spk_1"},{"id":102,"type":"pronunciation","alternatives":[{"confidence":"0.541","content":"아이"}],"start_time":"30.01","end_time":"30.02","speaker_label":"spk_1"},{"id":103,"type":"pronunciation","alternatives":[{"confidence":"0.48","content":"아이"}],"start_time":"30.03","end_time":"30.04","speaker_label":"spk_1"},{"id":104,"type":"pronunciation","alternatives":[{"confidence":"0.382","content":"아니"}],"start_time":"30.04","end_time":"30.049","speaker_label":"spk_1"},{"id":105,"type":"pronunciation","alternatives":[{"confidence":"0.378","content":"아니"}],"start_time":"30.059","end_time":"30.069","speaker_label":"spk_1"},{"id":106,"type":"pronunciation","alternatives":[{"confidence":"0.458","content":"아니"}],"start_time":"30.079","end_time":"30.09","speaker_label":"spk_1"},{"id":107,"type":"pronunciation","alternatives":[{"confidence":"0.444","content":"아니"}],"start_time":"30.1","end_time":"30.11","speaker_label":"spk_1"},{"id":108,"type":"pronunciation","alternatives":[{"confidence":"0.292","content":"아니"}],"start_time":"30.12","end_time":"30.129","speaker_label":"spk_1"},{"id":109,"type":"pronunciation","alternatives":[{"confidence":"0.42","content":"아니"}],"start_time":"30.139","end_time":"30.149","speaker_label":"spk_1"},{"id":110,"type":"pronunciation","alternatives":[{"confidence":"0.436","content":"아니"}],"start_time":"30.159","end_time":"30.17","speaker_label":"spk_1"},{"id":111,"type":"pronunciation","alternatives":[{"confidence":"0.419","content":"아니"}],"start_time":"30.18","end_time":"30.19","speaker_label":"spk_1"},{"id":112,"type":"pronunciation","alternatives":[{"confidence":"0.446","content":"아니"}],"start_time":"30.2","end_time":"30.209","speaker_label":"spk_1"},{"id":113,"type":"pronunciation","alternatives":[{"confidence":"0.347","content":"아니"}],"start_time":"30.219","end_time":"30.229","speaker_label":"spk_1"}],"audio_segments":[{"id":0,"transcript":"아 영상 좀 그만","start_time":"0.56","end_time":"1.559","speaker_label":"spk_0","items":[0,1,2,3]},{"id":1,"transcript":"봐. 아, 이거 내가 하루 스트레스 푸는 거 아니야. 또. 맨날 피곤하다. 왜 또 그래? 지금 새벽 두 시잖아, 지금. 아 내가 이걸로 좀 뭐라 하지 말아달라고 그랬잖아. 내가 이거 오늘 하루 내가 이거 피로 겨우 푸는 건데 이걸로 뭐라 그래?","start_time":"1.559","end_time":"15.539","speaker_label":"spk_1","items":[4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54]},{"id":2,"transcript":"아니 근데 영상을 보고 싶으면 다음날 그냥 피곤하다고 하지 말던가.","start_time":"15.88","end_time":"19.87","speaker_label":"spk_0","items":[55,56,57,58,59,60,61,62,63,64,65]},{"id":3,"transcript":"아 피곤할 수 있지. 근데 이것 이것조차 안 하면 내가 더 피곤하니까 해서 그래. 아","start_time":"20.52","end_time":"25.559","speaker_label":"spk_1","items":[66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82]},{"id":4,"transcript":"무슨 소리. 잠을 자야 안 피곤하지. 이게 무슨 말이야, 이게","start_time":"25.559","end_time":"28.52","speaker_label":"spk_0","items":[83,84,85,86,87,88,89,90,91,92,93,94,95]},{"id":5,"transcript":"도대체?","start_time":"28.52","end_time":"29.25","speaker_label":"spk_1","items":[96,97]},{"id":6,"transcript":"아이 아이 아이 아이 아이 아이 아니 아니 아니 아니 아니 아니 아니 아니 아니 아니","start_time":"29.899","end_time":"30.26","speaker_label":"spk_1","items":[98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113]}]}}
    """
}
