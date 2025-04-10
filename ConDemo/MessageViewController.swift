//
//  MessageViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit
import PhotosUI
import AVFoundation

final class MessageViewController: UIViewController {
    private let messageView = MessageView()
    
    private var picker: PHPickerViewController?
    private var camera = UIImagePickerController()
    private var audioPicker: UIDocumentPickerViewController?
    private var audioPlayer: AVAudioPlayer?
    private var isPlaying = false
    private var currentPlayingCell: MessageBubbleCell?
    private var updateTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = messageView
        
        setupNavigationBar()
        setupPHPicker()
        setupImagePicker()
        setupAudioPicker()
        setupAudio()
        messageView.setAudioDelegate(self)
        
        setupActions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopAudio() // 화면을 벗어나면 오디오 중지
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = .none
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        
        let waveButton = UIBarButtonItem(image: UIImage(systemName: "waveform"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = waveButton
    }
    
    private func setupActions() {
        messageView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setupPHPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        picker = PHPickerViewController(configuration: config)
        picker?.delegate = self
    }
    
    private func setupImagePicker() {
        camera.sourceType = .camera
        camera.delegate = self
    }
    
    private func setupAudioPicker() {
        // 오디오 파일 타입 지정
        let supportedTypes: [UTType] = [UTType.audio, UTType.mp3, UTType.wav, UTType.mpeg4Audio]
        
        // iOS 14 이상
        if #available(iOS 14.0, *) {
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
            // let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            self.audioPicker = documentPicker
        } else {
            // iOS 13
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            self.audioPicker = documentPicker
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addButtonTapped() {
        showAddOptions()
        print("추가버튼눌림")
    }
    
    private func showAddOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
            if let camera = self?.camera {
                self?.present(camera, animated: true)
            }
        }
        
        let photoLibraryAction = UIAlertAction(title: "앨범에서 선택", style: .default) { [weak self] _ in
            if let picker = self?.picker {
                self?.present(picker, animated: true)
            }
        }
        
        let recordingAction = UIAlertAction(title: "녹음 앱에서 선택", style: .default) { [weak self] _ in
            if let audioPicker = self?.audioPicker {
                self?.present(audioPicker, animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(recordingAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func setupAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("오디오 세션 설정 실패: \(error)")
        }
    }
    
    private func playAudio(data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("오디오 재생 실패 \(error)")
        }
    }
    
    // 오디오 재생 메서드
    func playAudio(from cell: MessageBubbleCell, url: URL, data: Data?) {
        // 이미 재생 중인 경우 중지
        if isPlaying && currentPlayingCell == cell {
            stopAudio()
            return
        }
        
        // 다른 오디오가 재생 중이면 중지
        if isPlaying {
            stopAudio()
        }
        
        do {
            if let data = data {
                audioPlayer = try AVAudioPlayer(data: data)
            } else {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
            }
            
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            isPlaying = true
            currentPlayingCell = cell
            
            cell.updateAudioButtonIcon(isPlaying: true)
            
            // 초기 재생 시간 설정
            let duration = formatTimeString(audioPlayer?.duration ?? 0)
            let currentTime = formatTimeString(audioPlayer?.currentTime ?? 0)
            cell.updateTimeLabel(current: currentTime, total: duration)
            
            // 타이머 시작 - 0.1초마다 시간 업데이트
            updateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAudioTime), userInfo: nil, repeats: true)
            
        } catch {
            print("오디오 재생 오류: \(error)")
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        
        // 타이머 중지
        updateTimer?.invalidate()
        updateTimer = nil
        
        if let cell = currentPlayingCell {
            cell.updateAudioButtonIcon(isPlaying: false)
        }
        
        currentPlayingCell = nil
    }
    
    @objc private func updateAudioTime() {
        guard let player = audioPlayer, let cell = currentPlayingCell else {
            updateTimer?.invalidate()
            updateTimer = nil
            return
        }
        
        let currentTime = formatTimeString(player.currentTime)
        let duration = formatTimeString(player.duration)
        
        cell.updateTimeLabel(current: currentTime, total: duration)
    }
    
    private func formatTimeString(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

extension MessageViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.messageView.sendImage(image: image)
                    }
                }
                
            }
        }
    }
}

extension MessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            messageView.sendImage(image: image)
        }
        
        picker.dismiss(animated: true)
    }
}

extension MessageViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        // 권한 설정 plist에서 할 필요는 없는지?
        let securityScoped = url.startAccessingSecurityScopedResource()
        
        do {
            let audioData = try Data(contentsOf: url)
            
            messageView.sendAudioMessage(url: url, data: audioData)
        } catch {
            print("파일 로드 실패 \(error)")
        }
        
        if securityScoped {
            url.stopAccessingSecurityScopedResource()
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}

extension MessageViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let cell = currentPlayingCell {
            cell.updateAudioButtonIcon(isPlaying: false)
        }
        
        isPlaying = false
        currentPlayingCell = nil
    }
}

extension MessageViewController: MessageBubbleCellDelegate {
    func didTapAudioButton(in cell: MessageBubbleCell, audioURL: URL, audioData: Data?) {
        playAudio(from: cell, url: audioURL, data: audioData)
    }
}
