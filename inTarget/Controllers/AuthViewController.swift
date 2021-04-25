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
    private let signInButton = UIButton(type: .system)
    private let containerSignUp = UIView()
    private let signUpButton = UIButton(type: .system)
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
    
    enum NetworkError: Error {
        case emptyField
        case incorrectField
    }
    
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
        
        errorLabel.text = ""
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont(name: "GothamPro-Light", size: 17)
        
        loginField.placeholder = "Email"
        loginField.autocapitalizationType = .none
        passwordField.placeholder = "Пароль"
        passwordField.isSecureTextEntry = true
        
        [loginSeparator, passwordSeparator].forEach { ($0).backgroundColor = .separator }
        
        [loginField, passwordField].forEach {
            ($0).font = UIFont(name: "GothamPro", size: 18)
            ($0).borderStyle = .none
            ($0).layer.cornerRadius = 6
            ($0).layer.masksToBounds = true
            containerTextView.addSubview($0)
        }
        
        signInButton.setTitle("Войти", for: .normal)
        signInButton.titleLabel?.font = UIFont(name: "GothamPro", size: 16)
        signInButton.setTitleColor(.background, for: .normal)
        signInButton.backgroundColor = .accent
        signInButton.setTitleColor(.lightGray, for: .selected)
        
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
        
        scrollView.keyboardDismissMode = .onDrag
        
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
        [signUpLabel, signUpButton].forEach { containerSignUp.addSubview($0) }
        [headLabel, quoteLabel, authorLabel, errorLabel, containerTextView, loginSeparator, passwordSeparator, signInButton, containerSignUp].forEach {scrollView.addSubview($0) }
        view.addSubview(scrollView)
        
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
            .horizontally(30)
            .sizeToFit()
        
        authorLabel.pin
            .below(of: quoteLabel)
            .margin(10)
            .right(20)
            .sizeToFit()
        
        containerTextView.pin.horizontally()
        
        loginField.pin
            .horizontally(16)
            .height(60)
            .top()
        
        passwordField.pin
            .horizontally(16)
            .height(60)
            .below(of: loginField)
        
        containerTextView.pin
            .wrapContent()
            .center()
        
        errorLabel.pin
            .above(of: containerTextView)
            .horizontally(16)
            .height(17)
        
        loginSeparator.pin
            .below(of: loginField)
            .horizontally(16)
            .height(0.1)
        
        passwordSeparator.pin
            .below(of: passwordField)
            .horizontally(16)
            .height(0.1)
        
        containerSignUp.pin
            .bottom(view.pin.safeArea.bottom + 30)
        
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
            .above(of: signUpButton)
            .marginBottom(20)
        
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
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height  + kbFrameSize.height)
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height - view.pin.safeArea.bottom)
    }
    
    @objc
    func kbDidHide() {
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height  - kbFrameSize.height)
    }
    
    @objc
    private func didTapSignUpButton() {
        let signUpController = SignUpController()
        
        signUpController.modalPresentationStyle = .fullScreen
        present(signUpController, animated: true, completion: nil)
    }
    @objc
    private func didTapSignInButton(){
        let auth = AuthModel()
        
        auth.signIn(loginField, passwordField) { isSignin, errorMessage  in
            if isSignin == true {
                self.errorLabel.text = ""
                let mainTabBarViewController = MainTabBarController()
                mainTabBarViewController.modalPresentationStyle = .fullScreen
                self.present(mainTabBarViewController, animated: true, completion: nil)
                
                UserDefaults.standard.setValue(true, forKey: "isAuth")
            } else if isSignin == false {
                self.errorLabel.text = errorMessage
                self.errorLabel.alpha = 1
                self.animateErrorLable(self.errorLabel)
            }
        }
        
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
    
    static let lightAccent = UIColor(red: 237/256,
                                     green: 237/256,
                                     blue: 246/256,
                                     alpha: 1)
    
    static let separator = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
}


