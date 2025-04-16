//
//  SummaryViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/16/25.
//

import Foundation

final class SummaryViewModel {
    private(set) var inputPath: URL
    private let transcriber = Transcriber()
    
    init(inputPath: URL) {
        self.inputPath = inputPath
    }
}

extension SummaryViewModel {
    
}
