//
//  MessageViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit

final class MessageViewController: UIViewController {
    private let messageView = MessageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = messageView
        
        setupNavigationBar()
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
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addButtonTapped() {
        showAddOptions()
        print("추가버튼눌림")
    }
    
    private func showAddOptions() {
        let alertController = UIAlertController(
        title: nil,
        message: nil,
        preferredStyle: .actionSheet
    )
        
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
        }
        
        let photoLibraryAction = UIAlertAction(title: "앨범에서 선택", style: .default) { [weak self] _ in
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
