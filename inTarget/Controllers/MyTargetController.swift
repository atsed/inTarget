//
//  MyTargetController.swift
//  inTarget
//
//  Created by Desta on 19.04.2021.
//

import UIKit
import PinLayout

class MyTargetController: UIViewController {
    private let imageView = UIImageView()
    private let scrollView = UIScrollView()
    private let database = DatabaseModel()
    
    private var kbFrameSize : CGRect = .zero
    
    var taskName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .background
        print("taskName: \(taskName)")
        //imageView.image
        
        [imageView].forEach { scrollView.addSubview($0) }
        view.addSubview(scrollView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin
            .horizontally()
            .vertically()
        
        imageView.pin
            .top(view.pin.safeArea.top + 30)
            .horizontally()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .accent
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()

        let backButtonImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        navigationController?.navigationBar.backItem?.backButtonTitle = ""
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
