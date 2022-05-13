//
//  AuthViewController.swift
//  inTarget
//
//  Created by Desta on 17.03.2021.
//

import UIKit
import PinLayout

enum AuthError: Error {
    case emptyInput
    case invalidInput
    case invalidTotp
    case unexpected
}

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
    private let activityIndicator = UIActivityIndicatorView()
    
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
        activityIndicator.hidesWhenStopped = true
        
        checkKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .background
        
        headLabel.text = "inTarget"
        headLabel.textColor = .accent
        headLabel.font = UIFont(name: "Noteworthy", size: 46)

        let action = UITapGestureRecognizer(target: self, action: #selector(didTapHeadLabel))
        action.numberOfTapsRequired = 10
        headLabel.isUserInteractionEnabled = true
        headLabel.addGestureRecognizer(action)
        
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
        signInButton.setTitleColor(.white, for: .normal)
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
        view.addSubview(activityIndicator)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        activityIndicator.pin
            .center()
        
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
    
    private func showTotpAlert(completion: @escaping (Result<String, Error>) -> Void) {
        let dialogMessage = UIAlertController(title: "Введите TOTP код", message: nil, preferredStyle: .alert)
        var textField = UITextField()

        dialogMessage.addTextField { alertTextField in
            textField.placeholder = "000000"

            textField = alertTextField
        }

        let okAction = UIAlertAction(title: "Ввод", style: .default, handler: { action in
            guard let text = textField.text  else {
                completion(.failure(AuthError.unexpected))
                return
            }
            completion(.success(text))
        })

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: { action in
            completion(.failure(AuthError.unexpected))
        })

        dialogMessage.addAction(cancelAction)
        dialogMessage.addAction(okAction)

        self.present(dialogMessage, animated: true, completion: nil)
    }

    private func updateState(with flug: Bool, errorMessage: AuthError) {
        self.activityIndicator.stopAnimating()

        var error: String = ""

        switch errorMessage {
        case .emptyInput:
            error = "Пустой логин или пароль"
        case .invalidInput:
            error = "Неверный логин или пароль"
        case .invalidTotp:
            error = "Неверный TOTP код"
        case .unexpected:
            error = ""
        }

        if flug == true {
            self.errorLabel.text = ""
            let mainTabBarViewController = MainTabBarController()
            mainTabBarViewController.modalPresentationStyle = .fullScreen
            self.present(mainTabBarViewController, animated: true, completion: nil)

            UserDefaults.standard.setValue(true, forKey: "isAuth")
        } else {
            self.errorLabel.text = error
            self.errorLabel.alpha = 1
            self.animateErrorLable(self.errorLabel)
        }
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
    private func didTapSignInButton() {
        showTotpAlert { [weak self] result in
            switch result {
            case .success(let code):
                guard
                    let email = self?.loginField.text,
                    let password = self?.passwordField.text,
                    !email.isEmpty,
                    !password.isEmpty
                else {
                    self?.updateState(with: false, errorMessage: AuthError.emptyInput)
                    return
                }

                let auth = AuthModel()

                auth.checkTotp(with: email, code: code) { result in
                    switch result {
                    case .failure(let errorMessage):
                        DispatchQueue.main.async {
                            self?.updateState(with: false, errorMessage: errorMessage as? AuthError ?? AuthError.unexpected)
                        }
                    case .success(_):
                        self?.activityIndicator.startAnimating()

                        auth.signIn(login: email, password: password) { result  in
                            switch result {
                            case .success(_):
                                DispatchQueue.main.async {
                                    self?.updateState(with: true, errorMessage: .unexpected)
                                }
                            case .failure(let errorMessage):
                                DispatchQueue.main.async {
                                    self?.updateState(with: false, errorMessage: errorMessage as? AuthError ?? AuthError.unexpected)
                                }
                            }
                        }
                    }
                }
            case .failure(let errorMessage):
                DispatchQueue.main.async {
                    self?.updateState(with: false, errorMessage: errorMessage as? AuthError ?? AuthError.unexpected)

                }
            }
        }
    }

    @objc
    private func didTapHeadLabel() {
        guard
            let email = self.loginField.text,
            let password = self.passwordField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            self.updateState(with: false, errorMessage: AuthError.emptyInput)
            return
        }


        let auth = AuthModel()

        auth.signIn(login: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.updateState(with: true, errorMessage: .unexpected)
                }
            case .failure(let errorMessage):
                DispatchQueue.main.async {
                    self?.updateState(with: false, errorMessage: errorMessage as? AuthError ?? AuthError.unexpected)
                }
            }
        }
    }
}
