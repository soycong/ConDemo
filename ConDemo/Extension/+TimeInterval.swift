//
//  +TimeInterval.swift
//  ConDemo
//
//  Created by 이명지 on 4/9/25.
//

import Foundation

extension TimeInterval {
    func formatTime() -> String {
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        let seconds = Int(self) % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
