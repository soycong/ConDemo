//
//  MessageViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit
import PhotosUI

final class MessageViewController: UIViewController {
    private let messageView = MessageView()
    
    private var picker: PHPickerViewController?
    private var camera = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = messageView
        
        setupNavigationBar()
        setupPHPicker()
        setupImagePicker()
        
        setupActions()
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
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(recordingAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
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
