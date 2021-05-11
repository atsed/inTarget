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
    private let errorLabel = UILabel()
    private let containerTextView = UIView()
    private let nameField = UITextField()
    private let surnameField = UITextField()
    private let loginField = UITextField()
    private let passwordField = UITextField()
    private let nameSeparator = UIView()
    private let surnameSeparator = UIView()
    private let loginSeparator = UIView()
    private let passwordSeparator = UIView()
    private let signUpButton = UIButton(type: .system)
    private let signUpLabel = UILabel()
    private let scrollView = UIScrollView()
    private let activityIndicator = UIActivityIndicatorView()
    
    private var kbFrameSize : CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        
        checkKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .background
        
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 0)
        let backItem = UIBarButtonItem(image: UIImage.init(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackButton))
        backItem.tintColor = .accent
        
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = backItem
        navigationBar.setItems([navItem], animated: false)
        
        navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        
        headLabel.text = "inTarget"
        headLabel.textColor = .accent
        headLabel.font = UIFont(name: "Noteworthy", size: 46)
        
        errorLabel.text = ""
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont(name: "GothamPro-Light", size: 17)
        
        nameField.placeholder = "Имя"
        surnameField.placeholder = "Фамилия"
        loginField.placeholder = "Email"
        loginField.autocapitalizationType = .none
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
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
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
        
        [headLabel, errorLabel,containerTextView, nameSeparator, surnameSeparator, loginSeparator, passwordSeparator, signUpButton, signUpLabel].forEach { scrollView.addSubview($0) }
        [scrollView, navigationBar, activityIndicator].forEach { view.addSubview($0) }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        activityIndicator.pin
            .center()
        
        scrollView.pin
            .horizontally()
            .vertically()
        
        navigationBar.pin
            .top(view.pin.safeArea.top)
            .horizontally(0)
            .height(40)
        
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
        
        errorLabel.pin
            .above(of: containerTextView)
            .horizontally(16)
            .height(17)
        
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
            .bottom(view.pin.safeArea.bottom + 8)
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
    
    @objc
    private func didTapSignUpButton(){
        activityIndicator.startAnimating()
        let signUp = SignUpModel()
        
        signUp.singUp(nameField, surnameField, loginField, passwordField) { [weak self] isSignUp, errorMessage in
            guard let self = self else {
                return
            }
            
            if isSignUp == true {
                self.activityIndicator.stopAnimating()
                let mainTabBarViewController = MainTabBarController()
                mainTabBarViewController.modalPresentationStyle = .fullScreen
                self.present(mainTabBarViewController, animated: true, completion: nil)
                
                UserDefaults.standard.setValue(true, forKey: "isAuth")
            } else if isSignUp == false {
                self.activityIndicator.stopAnimating()
                self.errorLabel.text = errorMessage
                self.errorLabel.alpha = 1
                self.animateErrorLable(self.errorLabel)
            }
        }
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
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height / 2)
    }
    
    @objc
    func kbDidHide() {
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height  - kbFrameSize.height)
    }
}
