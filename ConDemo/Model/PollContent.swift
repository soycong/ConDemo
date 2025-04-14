//
//  PollContent.swift
//  ConDemo
//
//  Created by seohuibaek on 4/11/25.
//

/// Poll 콘텐츠 모델
struct PollContent {
    // MARK: - Properties

    let title: String
    let body: String
    let dialogues: [(speaker: String, text: String)]
    let question: String
    let options: [String]

    // MARK: - Static Functions

    /// 기본 Poll 템플릿
    static func defaultTemplate() -> PollContent {
        PollContent(title: "Title",
                    body: "Body",
                    dialogues: [("She", "iowfiow opw. iweo qq?"),
                                ("He", "shfiui ewihfuh?\nhfiwh odn oo nciue nqq!")],
                    question: "What do you think?",
                    options: ["A.", "B.", "C.", "D."])
    }
}
