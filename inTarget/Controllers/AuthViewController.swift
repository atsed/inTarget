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
    private let signInButton = UIButton()
    private let containerSignUp = UIView()
    private let signUpButton = UIButton()
    private let signUpLabel = UILabel()
    
    private let quotes = [
        ["""
"Если вы работаете
над поставленными целями,
то эти цели будут работать на вас"
""", "- Джим Рон"],
        ["\"Успех — это успеть\"", "- Марина Цветаева"],
        ["\"Цели — это мечты с дедлайнами\"", "- Диана Скарф "]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        headLabel.text = "inTarget"
        headLabel.textColor = .accent
        headLabel.font = UIFont(name: "Noteworthy", size: 46)
        
        let randomOfQuotes = Int.random(in: 0..<quotes.count)
        print(quotes[randomOfQuotes][0])
        quoteLabel.text = quotes[randomOfQuotes][0]
        quoteLabel.font = UIFont(name: "GothamPro-Light", size: 18)
        quoteLabel.textColor = .darkGray
        quoteLabel.numberOfLines = 0
        quoteLabel.textAlignment = .justified
        
        authorLabel.text = quotes[randomOfQuotes][1]
        authorLabel.font = UIFont(name: "GothamPro-LightItalic", size: 18)
        authorLabel.textColor = .darkGray
        
        loginField.placeholder = "Email"
        
        passwordField.placeholder = "Пароль"
        passwordField.isSecureTextEntry = true
        
        
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
        
        [signUpLabel, signUpButton].forEach {
            containerSignUp.addSubview($0)
        }
        
        [headLabel, quoteLabel, authorLabel, containerTextView, signInButton, containerSignUp].forEach { view.addSubview($0) }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
            .below(of: loginField, aligned: .center)
            .marginTop(8)
                
        containerTextView.pin
            .wrapContent()
            .center()
        
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

