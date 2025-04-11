//
//  TestViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/11/25.
//

import UIKit

class TestViewController: UIViewController {
    
    private var didPresentSheet = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didPresentSheet {
            presentAsBottomSheet(VoiceNoteViewController())
            didPresentSheet = true
        }
    }

    func setupButtons() {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            
            stackView.axis = .vertical
            stackView.spacing = 20
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            return stackView
        }()
        
        let buttonArr = ["팩트 체크하기", "싸움일지 쓰기", "Poll 생성하기", "요약하기"]

        for i in 1...buttonArr.count {
            let button = UIButton()
            button.setTitle(buttonArr[i - 1], for: .normal)
            button.tag = i
            
            button.layer.cornerRadius = 30
            button.heightAnchor.constraint(equalToConstant: 60).isActive = true
            button.setTitleColor(.black, for: .normal)
            
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 0.5
            button.addTarget(self, action: #selector(navigateToVC(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    @objc func navigateToVC(_ sender: UIButton) {
        let destinationVC: UIViewController

        switch sender.tag {
        case 1:
            destinationVC = MessageViewController()
        case 2:
            destinationVC = StruggleJournalViewController()
        case 3:
            destinationVC = PollRecommendViewController()
        case 4:
            destinationVC = SummaryEditViewController()
        default:
            return
        }
        
        didPresentSheet = false
        navigationController?.pushViewController(destinationVC, animated: true)
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
            sheet.largestUndimmedDetentIdentifier = .large
        }
        
        present(viewController, animated: true)
    }
}
