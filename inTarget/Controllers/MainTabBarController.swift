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
    private let vc5 = ProfileContainer.assemble(with: ProfileContext()).viewController
    
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
        vc5.tabBarItem.image = UIImage(named: "vc5")
        [vc1, vc2, vc3, vc4, vc5].forEach {
            ($0).tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
        }
        
        setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
    }
    
    func reloadVC1() {
        vc1.reloadAll()
    }
    
    func reloadVC2(valueSegmCon: Int) {
        vc2.valueSegmCon = valueSegmCon
    }
        
    func reloadVC3() {
        guard let viewController = vc3.viewControllers.first as? GroupsController else {
            return
        }
        viewController.reloadGroups()
    }
    
    func reloadVC4() {
        guard let viewController = vc4.viewControllers.first as? MyTargetsController else {
            return
        }
        viewController.reloadTasks()
    }
    
    func reloadVC5() {
        debugPrint("HERE")
        vc5.viewDidLoad()
    }
    
    func openGoalVC3(with groupID: String) {
        self.selectedIndex = 2
        (vc3.topViewController as? GroupsController)?.pushGroupController(groupID: groupID)
    }
    
    func openGoalVC4(with taskName: String) {
        self.selectedIndex = 3
        (vc4.topViewController as? MyTargetsController)?.pushMyTargetController(taskName: taskName)
    }
    
    func reloadTasks() {
        reloadVC1()
        reloadVC3()
        reloadVC4()
        reloadVC5()
    }
    
    func reloadAvatars() {
        vc1.reloadAvatar()
        
        guard let vc3 = vc3.viewControllers.first as? GroupsController else {
            return
        }
        
        vc3.reloadAvatar()
        
        guard let vc4 = vc4.viewControllers.first as? MyTargetsController else {
            return
        }
        
        vc4.reloadAvatar()
        
        vc5.viewDidLoad()
    }
}
