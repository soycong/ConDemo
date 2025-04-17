//
//  VoiceNoteViewModel.swift
//  ConDemo
//
//  Created by seohuibaek on 4/15/25.
//

import Foundation

final class VoiceNoteViewModel {
    // MARK: - Properties

    var onMessagesUpdated: (([MessageData]) -> Void)?
    var onError: ((Error) -> Void)?

    var messages: [MessageData] = [] {
        didSet {
            onMessagesUpdated?(messages)
        }
    }
}
