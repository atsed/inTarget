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
    private let vc3 = MembersController()
    private let vc4 = UINavigationController(rootViewController: MyTargetsController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        
        setupTabBar()
        
        //tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
    }
    
    func setupTabBar() {
        vc1.tabBarItem.image = UIImage(named: "vc1")
        vc2.tabBarItem.image = UIImage(named: "vc2")
        vc3.tabBarItem.image = UIImage(named: "vc3")
        vc4.tabBarItem.image = UIImage(named: "vc4")
        [vc1, vc2, vc3, vc4].forEach {
            ($0).tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
        }
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: false)
    }
    
    func reloadVC1() {
        vc1.reloadTasks()
    }
    
    func reloadVC4() {
        guard let viewController = vc4.topViewController as? MyTargetsController else {
            return
        }
        viewController.reloadTasks()
    }
    
    func openGoal(with taskName: String) {
        self.selectedIndex = 3
        (vc4.topViewController as? MyTargetsController)?.pushMyTargetController(taskName: taskName)
    }
}
