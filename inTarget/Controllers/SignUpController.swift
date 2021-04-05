//
//  SignUpController.swift
//  inTarget
//
//  Created by Desta on 04.04.2021.
//

import UIKit
import PinLayout

class SignUpController : UIViewController {
    private let navigationBar = UINavigationBar()
    private let headLabel = UILabel()
    private let containerTextView = UIView()
    private let nameField = UITextField()
    private let surnameField = UITextField()
    private let loginField = UITextField()
    private let passwordField = UITextField()
    private let nameSeparator = UIView()
    private let surnameSeparator = UIView()
    private let loginSeparator = UIView()
    private let passwordSeparator = UIView()
    private let signUpButton = UIButton()
    private let signUpLabel = UILabel()
    private let scrollView = UIScrollView()
    
    private var kbFrameSize : CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .background
        
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 0)
        let navItem = UINavigationItem()
        let backItem = UIBarButtonItem(image: UIImage.init(systemName: "chevron.backward"), style: .plain, target: nil, action: #selector(didTapBackButton))
        backItem.tintColor = .accent
        navItem.leftBarButtonItem = backItem
        navigationBar.setItems([navItem], animated: false)
        navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        
        headLabel.text = "inTarget"
        headLabel.textColor = .accent
        headLabel.font = UIFont(name: "Noteworthy", size: 46)
                
        nameField.placeholder = "Имя"
        surnameField.placeholder = "Фамилия"
        loginField.placeholder = "Email"
        passwordField.placeholder = "Пароль"
        passwordField.isSecureTextEntry = true
        
        [nameSeparator, surnameSeparator, loginSeparator, passwordSeparator].forEach { ($0).backgroundColor = .separator }
        
        
        [nameField, surnameField, loginField, passwordField].forEach {
            ($0).font = UIFont.systemFont(ofSize: 17, weight: .regular)
            ($0).borderStyle = .none
            ($0).layer.cornerRadius = 6
            ($0).layer.masksToBounds = true
            containerTextView.addSubview($0)
        }
        
        signUpButton.setTitle("Присоединиться", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "GothamPro", size: 16)
        signUpButton.setTitleColor(.background, for: .normal)
        signUpButton.backgroundColor = .accent
        signUpButton.layer.cornerRadius = 14
        signUpButton.layer.masksToBounds = true
        
        signUpLabel.text = """
Нажимая “Присоединиться”, вы принимаете Условия
использования и Политику конфиденциальности
inTarget
"""
        signUpLabel.numberOfLines = 0
        signUpLabel.font = UIFont(name: "GothamPro-Light", size: 12)
        signUpLabel.textColor = .separator
        signUpLabel.textAlignment = .center
        
        scrollView.keyboardDismissMode = .onDrag
        
        [headLabel, containerTextView, nameSeparator, surnameSeparator, loginSeparator, passwordSeparator, signUpButton, signUpLabel].forEach { scrollView.addSubview($0) }
        view.addSubview(scrollView)
        view.addSubview(navigationBar)
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    func checkKeyboardNotifications() {
         NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func kbDidShow(_ notification : Notification) {
        let userInfo = notification.userInfo
        kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height  + kbFrameSize.height)
    }
    
    @objc
    func kbDidHide() {
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height  - kbFrameSize.height)
        scrollView.contentOffset = CGPoint.zero
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin
            .horizontally()
            .vertically()
        
        navigationBar.pin
            .top(view.pin.safeArea.top)
            .horizontally(0)
            .height(40)
            //.sizeToFit()
        
        headLabel.pin
            .top(view.pin.safeArea.top + 34)
            .sizeToFit()
            .hCenter()
        
        containerTextView.pin.horizontally()
        
        nameField.pin
            .horizontally(16)
            .height(60)
            .top()
        
        surnameField.pin
            .horizontally(16)
            .height(60)
            .below(of: nameField)
        
        loginField.pin
            .horizontally(16)
            .height(60)
            .below(of: surnameField)
        
        passwordField.pin
            .horizontally(16)
            .height(60)
            .below(of: loginField)
        
        containerTextView.pin
            .wrapContent()
            .center()
        
        nameSeparator.pin
            .below(of: nameField)
            .horizontally(16)
            .height(0.1)
        
        surnameSeparator.pin
            .below(of: surnameField)
            .horizontally(16)
            .height(0.1)
        
        loginSeparator.pin
            .below(of: loginField)
            .horizontally(16)
            .height(0.1)
        
        passwordSeparator.pin
            .below(of: passwordField)
            .horizontally(16)
            .height(0.1)
        
        signUpLabel.pin
            .bottom(view.pin.safeArea.bottom)
            .horizontally(30)
            .sizeToFit()
        
        signUpButton.pin
            .horizontally(16)
            .height(56)
            .above(of: signUpLabel)
            .marginBottom(20)
        
    }
    
    @objc
    private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
}
