//
//  ParticipantsController.swift
//  inTarget
//
//  Created by Георгий on 06.04.2021.
//


import UIKit
import PinLayout

class ParticipantsController: UIViewController {
    
    let logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.addSubview(logoutButton)
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .white
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoutButton.pin
            .center()
            .size(CGSize(width: 100, height: 30))
    }
    
    @objc
    func didTapLogoutButton() {
        UserDefaults.standard.setValue(false, forKey: "isAuth")
    }
}

