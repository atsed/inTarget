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
    private let vc3 = UINavigationController(rootViewController: GroupsController())
    private let vc4 = UINavigationController(rootViewController: MyTargetsController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
                
        setupTabBar()
        
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
    
    func reloadVC2(valueSegmCon: Int) {
        vc2.valueSegmCon = valueSegmCon
    }
    
    func reloadVC4() {
        guard let viewController = vc4.viewControllers.first as? MyTargetsController else {
            return
        }
        viewController.reloadTasks()
    }
    
    func reloadVC3() {
        guard let viewController = vc3.viewControllers.first as? GroupsController else {
            return
        }
        viewController.reloadGroups()
    }
    
    func openGoalVC3(with groupName: String) {
        self.selectedIndex = 2
        (vc3.topViewController as? GroupsController)?.pushGroupController(groupName: groupName)
    }
    
    func openGoalVC4(with taskName: String) {
        self.selectedIndex = 3
        (vc4.topViewController as? MyTargetsController)?.pushMyTargetController(taskName: taskName)
    }
    
    func reloadTasks() {
        reloadVC1()
        reloadVC4()
    }
}
