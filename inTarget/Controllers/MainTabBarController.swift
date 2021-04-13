//
//  MainTabBarController.swift
//  inTarget
//
//  Created by Георгий on 06.04.2021.
//

import UIKit
import PinLayout

final class MainTabBarController: UITabBarController {
    private let vc1 = TargetsController()
    private let vc2 = NewTargetController()
    private let vc3 = MyTargetController()
    private let vc4 = MembersController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        
        setupTabBar()
    }
    
    func setupTabBar(){
        vc1.tabBarItem.image = UIImage(named: "icon1")
        vc2.tabBarItem.image = UIImage(named: "Glyph")
        vc3.tabBarItem.image = UIImage(named: "support")
        vc4.tabBarItem.image = UIImage(named: "Vector")
        [vc1, vc2, vc3, vc4].forEach {$0.tabBarItem.badgeColor = .accent}
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: false)
    }
}

