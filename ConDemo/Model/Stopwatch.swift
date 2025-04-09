//
//  Stopwatch.swift
//  ConDemo
//
//  Created by 이명지 on 4/9/25.
//

import Foundation

protocol StopwatchDelegate: AnyObject {
    func stopwatchDidUpdate(_ stopwatch: Stopwatch, elapsedTime: TimeInterval)
}

final class Stopwatch {
    // MARK: - Properties

    private(set) var isRunning = false
    weak var delegate: StopwatchDelegate?

    private var timer: Timer?
    private var startTime: Date?
    private var accumulatedTime: TimeInterval = 0
    private var lastTimeStamp: Date?

    // MARK: - Computed Properties

    var elapsedTime: TimeInterval {
        if let startTime, isRunning {
            accumulatedTime + Date().timeIntervalSince(startTime)
        } else {
            accumulatedTime
        }
    }

    // MARK: - Functions

    func start() {
        guard !isRunning else {
            return
        }

        startTime = Date()
        lastTimeStamp = startTime

        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update),
                                     userInfo: nil, repeats: true)
        isRunning = true
    }

    func pause() {
        guard isRunning else {
            return
        }

        if let startTime {
            accumulatedTime += Date().timeIntervalSince(startTime)
        }

        timer?.invalidate()
        timer = nil
        startTime = nil
        isRunning = false
    }

    func reset() {
        timer?.invalidate()
        timer = nil
        startTime = nil
        accumulatedTime = 0
        isRunning = false

        delegate?.stopwatchDidUpdate(self, elapsedTime: 0)
    }

    @objc
    private func update() {
        delegate?.stopwatchDidUpdate(self, elapsedTime: elapsedTime)
    }
}
