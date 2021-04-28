//
//  GroupsController.swift
//  inTarget
//
//  Created by Георгий on 06.04.2021.
//

import UIKit
import PinLayout

class GroupsController: UIViewController {
    private let headLabel = UILabel()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(GroupCell.self, forCellWithReuseIdentifier: "GroupCell")
        cv.register(NewGroupCell.self, forCellWithReuseIdentifier: "NewGroupCell")
        return cv
    }()
    
    private let groupDatabase = GroupDatabaseModel()
    
    var data: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadGroups()
        
        view.backgroundColor = .background
        
        headLabel.text = "Группы"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
        
        collectionView.backgroundColor = .white
        collectionView.layer.masksToBounds = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        [headLabel, collectionView].forEach { view.addSubview($0)}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headLabel.pin
            .top(view.pin.safeArea.top + 30)
            .left(view.pin.safeArea.left + 30)
            .sizeToFit()
        
        collectionView.pin
            .below(of: headLabel)
            .marginTop(30)
            .horizontally(16)
            .bottom(6)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    public func pushGroupController(groupName : String) {
        let groupController = GroupController()
        groupController.groupName = groupName
        self.navigationController?.pushViewController(groupController, animated: true)
    }
    
    @objc
    func didTapAddButton() {
        (self.tabBarController as? MainTabBarController)?.reloadVC2(valueSegmCon: 1)
        tabBarController?.selectedIndex = 1
    }
    
    @objc
    func didTapOpenButton(groupID : String) {
        (self.tabBarController as? MainTabBarController)?.openGoalVC3(with: groupID)
    }
    
    func reloadGroups() {
        groupDatabase.getGroups() { result in
            switch result {
            case .success(let groups):
                self.data = groups
                print("DATAAAAAA: \(self.data)")
                self.collectionView.reloadData()
            case .failure:
                return
            }
        }
    }
}


extension GroupsController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == data.count {
            guard let newGroupCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewGroupCell", for: indexPath) as? NewGroupCell else {
                return UICollectionViewCell()
            }
            newGroupCell.delegate = self
            return newGroupCell
        }
        
        guard let groupCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as? GroupCell else {
            return UICollectionViewCell()
        }
    
        let group = data[indexPath.row]
        groupCell.configure(with: group)
        groupCell.delegate = self
        
        return groupCell
    }

}

extension GroupsController: GroupCellDelegate, NewGroupCellDelegate {
    func didTapActionButton() {
        didTapAddButton()
    }
    
    func didTapOpenGroupButton(groupID : String) {
        didTapOpenButton(groupID: groupID)
    }
    
}
