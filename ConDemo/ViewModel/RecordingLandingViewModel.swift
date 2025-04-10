//
//  RecordingLandingViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/10/25.
//

import AVFoundation

final class RecordingLandingViewModel {
    // MARK: - Properties

    var onPermissionDenied: (() -> Void)?
    var onPermissionGranted: (() -> Void)?

    // MARK: - Functions

    func checkRecordingPermission() {
        let status = AVAudioSession.sharedInstance().recordPermission

        switch status {
        case .granted:
            onPermissionGranted?()
        case .denied:
            onPermissionDenied?()
        case .undetermined:
            requestMicrophonePermission { [weak self] granted in
                if granted {
                    self?.onPermissionGranted?()
                } else {
                    self?.onPermissionDenied?()
                }
            }
        default:
            requestMicrophonePermission { [weak self] granted in
                if granted {
                    self?.onPermissionGranted?()
                } else {
                    self?.onPermissionDenied?()
                }
            }
        }
    }

    private func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}
