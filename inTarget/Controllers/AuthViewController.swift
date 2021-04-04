//
//  AuthViewController.swift
//  inTarget
//
//  Created by Desta on 17.03.2021.
//

import UIKit
import PinLayout

class AuthViewController: UIViewController {
    private let headLabel = UILabel()
    private let quoteLabel = UILabel()
    private let authorLabel = UILabel()
    private let errorLabel = UILabel()
    private let containerTextView = UIView()
    private let loginField = UITextField()
    private let passwordField = UITextField()
    private let loginSeparator = UIView()
    private let passwordSeparator = UIView()
    private let signInButton = UIButton()
    private let containerSignUp = UIView()
    private let signUpButton = UIButton()
    private let signUpLabel = UILabel()
    private let scrollView = UIScrollView()
    
    private var kbFrameSize : CGRect = .zero
        
    private let quotes = [
        ["""
"Если вы работаете
над поставленными целями,
то эти цели будут работать на вас"
""", "- Джим Рон"],
        ["""
"Успех — это успеть"
""", "- Марина Цветаева"],
        ["""
Цели — это мечты с дедлайнами"
""", "- Диана Скарф "]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .background
        
        headLabel.text = "inTarget"
        headLabel.textColor = .accent
        headLabel.font = UIFont(name: "Noteworthy", size: 46)
        
        let randomOfQuotes = Int.random(in: 0..<quotes.count)
        quoteLabel.text = quotes[randomOfQuotes][0]
        quoteLabel.font = UIFont(name: "GothamPro-Light", size: 18)
        quoteLabel.textColor = .darkGray
        quoteLabel.numberOfLines = 0
        quoteLabel.textAlignment = .justified
        
        authorLabel.text = quotes[randomOfQuotes][1]
        authorLabel.font = UIFont(name: "GothamPro-LightItalic", size: 18)
        authorLabel.textColor = .darkGray
        
        loginField.placeholder = "Email"
        loginSeparator.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        passwordField.placeholder = "Пароль"
        passwordField.isSecureTextEntry = true
        passwordSeparator.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        
        [loginField, passwordField].forEach {
            ($0).font = UIFont.systemFont(ofSize: 17, weight: .regular)
            ($0).borderStyle = .none
            ($0).layer.cornerRadius = 6
            ($0).layer.masksToBounds = true
            containerTextView.addSubview($0)
        }
        
        signInButton.setTitle("Войти", for: .normal)
        signInButton.titleLabel?.font = UIFont(name: "GothamPro", size: 16)
        signInButton.setTitleColor(.background, for: .normal)
        signInButton.backgroundColor = .accent
        
        signUpButton.setTitle("Зарегистрируйтесь", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "GothamPro", size: 15)
        signUpButton.setTitleColor(.accent, for: .normal)
        
        [signInButton, signUpButton].forEach {
            ($0).layer.cornerRadius = 14
            ($0).layer.masksToBounds = true
        }
        
        signUpLabel.text = "У вас нет аккаунта? "
        signUpLabel.font = UIFont(name: "GothamPro", size: 15)
        signUpLabel.textColor = .darkGray
        
        [signUpLabel, signUpButton].forEach {
            containerSignUp.addSubview($0)
        }
        
        [headLabel, quoteLabel, authorLabel, containerTextView, loginSeparator, passwordSeparator, signInButton, containerSignUp].forEach {scrollView.addSubview($0) }
        
        scrollView.keyboardDismissMode = .onDrag
        
        view.addSubview(scrollView)
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
            .vertically()
            .horizontally()
        
        headLabel.pin
            .top(view.pin.safeArea.top + 34)
            .sizeToFit()
            .hCenter()
        
        quoteLabel.pin
            .below(of: headLabel)
            .marginTop(50)
            .left(30)
            .right(30)
            .sizeToFit()
            .hCenter()
        
        authorLabel.pin
            .below(of: quoteLabel)
            .margin(10)
            .right(20)
            .sizeToFit()
            .hCenter()
        
        containerTextView.pin.horizontally()
        
        loginField.pin
            .horizontally(16)
            .height(60)
            .top()
        
        passwordField.pin
            .horizontally(16)
            .height(60)
            .below(of: loginField)
            .marginTop(8)
                
        containerTextView.pin
            .wrapContent()
            .center()
        
        loginSeparator.pin
            .below(of: loginField)
            .horizontally(16)
            .height(0.1)
        
        passwordSeparator.pin
            .below(of: passwordField)
            .horizontally(16)
            .height(0.1)
        
        containerSignUp.pin
            .bottom(view.pin.safeArea.top + 8)
        
        signUpLabel.pin
            .sizeToFit()
            .vCenter()
        
        signUpButton.pin
            .right(of: signUpLabel)
            .sizeToFit()
            .vCenter()
        
        containerSignUp.pin
            .wrapContent()
            .hCenter()
        
        signInButton.pin
            .horizontally(16)
            .height(56)
            .above(of: signUpButton, aligned: .center)
            .marginBottom(20)
        
    }
    
}


extension UIColor {
//    static let background = UIColor(red: 20/256,
//                                green: 21/256,
//                                blue: 24/256,
//                                alpha: 1)
    static let background = UIColor.white
    
//    static let accent = UIColor(red: 167/256,
//                                green: 238/256,
//                                blue: 237/256,
//                                alpha: 1)
    static let accent = UIColor(red: 97/256,
                                    green: 62/256,
                                    blue: 234/256,
                                    alpha: 1)

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
        
    }
}

