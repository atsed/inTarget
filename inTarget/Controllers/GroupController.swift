//
//  GroupController.swift
//  inTarget
//
//  Created by Desta on 28.04.2021.
//

import UIKit

class GroupController: UIViewController {
    
    private var group : Group = Group(randomName: "", title: "", date: "", image: "")
    public var groupName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
    
}
