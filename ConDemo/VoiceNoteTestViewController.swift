//
//  VoiceNoteTestViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/10/25.
//

import UIKit

class VoiceNoteTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    private var didPresentSheet = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didPresentSheet {
            presentAsBottomSheet(VoiceNoteViewController())
            didPresentSheet = true
        }
    }
    
    func presentAsBottomSheet(_ viewController: UIViewController) {
        // 시트 프레젠테이션 컨트롤러 구성
        let customIdentifier = UISheetPresentationController.Detent.Identifier("custom20")
        let customDetent = UISheetPresentationController.Detent.custom(identifier: customIdentifier) { context in
            return 20 // 원하는 높이
        }
        
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [
                customDetent,
                .medium(), // 화면 중간 높이까지
                .large()   // 전체 화면 높이
            ]
            
            // 사용자가 시트를 끌어올릴 수 있도록 설정
            sheet.prefersGrabberVisible = true
            
            // 시작 시 어떤 높이로 표시할지 설정
            sheet.selectedDetentIdentifier = .some(customIdentifier)

            // 드래그 중에 아래 뷰가 어두워지지 않도록 설정
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        
        present(viewController, animated: true)
    }
}
