//
//  MyTargetsController.swift
//  inTarget
//
//  Created by Георгий on 06.04.2021.
//

import UIKit
import PinLayout

class MyTargetsController: UIViewController {
    let logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoutButton.pin
            .center()
            .size(CGSize(width: 100, height: 30))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    public func pushMyTargetController(taskName : String) {
        let myTargetController = MyTargetController()
        myTargetController.taskName = taskName
        self.navigationController?.pushViewController(myTargetController, animated: true)
    }
    
    private func setup() {
        view.backgroundColor = .green
        view.addSubview(logoutButton)
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .white
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    }
    
    @objc
    func didTapLogoutButton() {
        UserDefaults.standard.setValue(false, forKey: "isAuth")
        
        let authViewController = AuthViewController()
        authViewController.modalPresentationStyle = .fullScreen
        
        present(authViewController, animated: false, completion: nil)
    }
}

