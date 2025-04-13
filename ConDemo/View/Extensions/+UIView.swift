//
//  +UIView.swift
//  ConDemo
//
//  Created by seohuibaek on 4/13/25.
//

import UIKit
import SnapKit

extension UIView {
    
    // 키보드 정보 저장
    private struct KeyboardInfo {
        weak var constraint: Constraint?
        var defaultInset: CGFloat // 기본 여백
        var textViews: [UITextView]
    }
    
    // Associated Object를 위한 키
    private static var keyboardInfoKey: UInt8 = 0
    private static var observersKey: UInt8 = 0
    
    // 키보드 정보 저장 프로퍼티
    private var keyboardInfo: KeyboardInfo? {
        get {
            return objc_getAssociatedObject(self, &UIView.keyboardInfoKey) as? KeyboardInfo
        }
        set {
            objc_setAssociatedObject(
                self,
                &UIView.keyboardInfoKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    // observer 저장 프로퍼티
    private var observers: [NSObjectProtocol]? {
        get {
            return objc_getAssociatedObject(self, &UIView.observersKey) as? [NSObjectProtocol]
        }
        set {
            objc_setAssociatedObject(
                self,
                &UIView.observersKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    func setupKeyboard(
        bottomConstraint: Constraint,
        defaultInset: CGFloat,
        textViews: [UITextView]
    ) {
        removeKeyboard() // 기존 설정 제거
        
        // 키보드 정보 저장
        keyboardInfo = KeyboardInfo(
            constraint: bottomConstraint,
            defaultInset: defaultInset,
            textViews: textViews
        )
        
        // 툴바 설정
        let toolbar = createKeyboardToolbar()
        textViews.forEach { $0.inputAccessoryView = toolbar }
        
        // 키보드 옵저버 등록
        var newObservers = [NSObjectProtocol]()
        
        let showObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.keyboardWillShow(notification: notification)
        }
        
        let hideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.keyboardWillHide(notification: notification)
        }
        
        newObservers.append(showObserver)
        newObservers.append(hideObserver)
        
        observers = newObservers
    }
    
    // 키보드 처리 해제
    func removeKeyboard() {
        if let observers = observers {
            for observer in observers {
                NotificationCenter.default.removeObserver(observer)
            }
        }
        
        observers = nil
        keyboardInfo = nil
    }
    
    // 키보드 툴바 생성
    private func createKeyboardToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissKeyboard)
        )
        
        toolbar.items = [flexSpace, doneButton]
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    // 키보드 표시 처리
    private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let info = keyboardInfo else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
        
        for textView in info.textViews {
            var contentInset = textView.contentInset
            contentInset.bottom = keyboardHeight
            textView.contentInset = contentInset
            
            var scrollIndicatorInsets = textView.scrollIndicatorInsets
            scrollIndicatorInsets.bottom = keyboardHeight
            textView.scrollIndicatorInsets = scrollIndicatorInsets
            
            if textView.isFirstResponder, let selectedRange = textView.selectedTextRange {
                textView.scrollRectToVisible(textView.caretRect(for: selectedRange.end), animated: true)
            }
        }
        
        info.constraint?.update(inset: keyboardHeight + 10)
        
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }
    
    // 키보드 숨김 처리
    private func keyboardWillHide(notification: Notification) {
        guard let info = keyboardInfo else { return }
        
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
        
        for textView in info.textViews {
            var contentInset = textView.contentInset
            contentInset.bottom = 0
            textView.contentInset = contentInset
            
            var scrollIndicatorInsets = textView.scrollIndicatorInsets
            scrollIndicatorInsets.bottom = 0
            textView.scrollIndicatorInsets = scrollIndicatorInsets
        }
        
        info.constraint?.update(inset: info.defaultInset)
        
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }
    
    // 키보드 닫기
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}
