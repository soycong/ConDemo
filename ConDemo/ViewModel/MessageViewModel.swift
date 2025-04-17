//
//  MessageViewModel.swift
//  ConDemo
//
//  Created by seohuibaek on 4/17/25.
//

import Foundation
import UIKit

protocol MessageViewModelDelegate: AnyObject {
    func messageViewModelDidUpdateMessages(_ viewModel: MessageViewModel)
    func messageViewModel(_ viewModel: MessageViewModel, didChangeLoadingState isLoading: Bool)
    func messageViewModel(_ viewModel: MessageViewModel, didReceiveError error: Error)
}

final class MessageViewModel {
    // MARK: - Properties
    
    var analysisTitle: String = ""
    
    private(set) var messages: [MessageData] = []
    private(set) var isLoading: Bool = false {
        didSet {
            delegate?.messageViewModel(self, didChangeLoadingState: isLoading)
        }
    }
    
    weak var delegate: MessageViewModelDelegate?
    
    // MARK: - Functions
    
    func sendMessage(_ text: String) {
        // 사용자 메시지 추가
        addMessage(text: text, isFromCurrentUser: true)
        
        isLoading = true
        
        ChatGPTManager.shared.getResponse(to: text) { [weak self] result in
            guard let self = self else { return }
            
            // 로딩 상태 업데이트
            self.isLoading = false
            
            switch result {
            case .success(let response):
                self.addMessage(text: response, isFromCurrentUser: false)
                
            case .failure(let error):
                self.delegate?.messageViewModel(self, didReceiveError: error)
                self.addMessage(text: "죄송합니다. 응답을 가져오는 중 오류가 발생했습니다.", isFromCurrentUser: false)
            }
        }
    }
    
    func sendMessageWithTranscript(_ text: String, analysisTitle: String) {
        addMessage(text: text, isFromCurrentUser: true)
        
        isLoading = true
        
        // CoreData에서 대화 내용 가져오기
        let transcriptMessages = CoreDataManager.shared.fetchMessages(from: analysisTitle)
        
        // 대화 내용을 텍스트로 변환
        let transcript = transcriptMessages.map {
            "\($0.isFromCurrentUser ? "나" : "상대방"): \($0.text)"
        }.joined(separator: "\n")
        
        // 대화 내용을 포함한 요청 보내기
        ChatGPTManager.shared.getResponseWithTranscript(userMessage: text, transcript: transcript) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let response):
                self.addMessage(text: response, isFromCurrentUser: false)
                
            case .failure(let error):
                self.delegate?.messageViewModel(self, didReceiveError: error)
                self.addMessage(text: "죄송합니다. 응답을 가져오는 중 오류가 발생했습니다.", isFromCurrentUser: false)
            }
        }
    }
    
    private func addMessage(text: String, isFromCurrentUser: Bool) {
        let message = MessageData(text: text, isFromCurrentUser: isFromCurrentUser, timestamp: Date())
        messages.append(message)
        delegate?.messageViewModelDidUpdateMessages(self)
    }
    
    func getMessage(at index: Int) -> MessageData? {
        guard index < messages.count else { return nil }
        return messages[index]
    }
    
    func getMessageCount() -> Int {
        return messages.count
    }
}
