//
//  MessageView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/8/25.
//

import UIKit
import SnapKit

final class MessageView: UIView {
    
    private let inputTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "검색"
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 1
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always

        return textField
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        addSubview(inputTextField)
        
        inputTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(16)
            make.height.equalTo(38) // 추후 수정 필요
        }
    }
}
