//
//  TestViewController.swift
//  ConDemo
//
//  Created by seohuibaek on 4/11/25.
//

import UIKit

class TestViewController: UIViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
    }

    // MARK: - Functions

    func setupButtons() {
        let stackView: UIStackView = {
            let stackView: UIStackView = .init()

            stackView.axis = .vertical
            stackView.spacing = 20
            stackView.translatesAutoresizingMaskIntoConstraints = false

            return stackView
        }()

        let buttonArr = ["팩트 체크하기", "싸움일지 쓰기", "Poll 생성하기", "요약하기"]

        for i in 1 ... buttonArr.count {
            let button: UIButton = .init()
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

    @objc
    func navigateToVC(_ sender: UIButton) {
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

        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
