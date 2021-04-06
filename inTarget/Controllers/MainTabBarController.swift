//
//  MainTabBarController.swift
//  inTarget
//
//  Created by Георгий on 06.04.2021.
//

import UIKit
import PinLayout

final class MainTabBarController: UITabBarController {
    let vc1 = AimsController()
    let vc2 = NewAimController()
    let vc3 = MyAimController()
    let vc4 = ParticipantsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        
        setupTabBar()
    }
    
    func setupTabBar(){
        vc1.tabBarItem.image = UIImage(named: "reports")
        vc2.tabBarItem.image = UIImage(named: "Glyph")
        vc3.tabBarItem.image = UIImage(named: "support")
        vc4.tabBarItem.image = UIImage(named: "Vector")
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: false)
    }
}

