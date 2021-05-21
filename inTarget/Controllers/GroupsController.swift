//
//  GroupsController.swift
//  inTarget
//
//  Created by Георгий on 06.04.2021.
//

import UIKit
import PinLayout

class GroupsController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private let headLabel = UILabel()
    private let avatarButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView()
    private let avatarActivityIndicator = UIActivityIndicatorView()
    
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
    
    private let database = DatabaseModel()
    private let groupDatabase = GroupDatabaseModel()
    private let imageLoader = InjectionHelper.imageLoader
    
    var data: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        avatarActivityIndicator.hidesWhenStopped = true
        reloadAvatar()
        reloadGroups()
        
        view.backgroundColor = .background
        
        headLabel.text = "Группы"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
        
        avatarButton.setImage(UIImage(named: "avatar"), for: .normal)
        avatarButton.backgroundColor = .accent
        avatarButton.contentVerticalAlignment = .fill
        avatarButton.contentHorizontalAlignment = .fill
        avatarButton.contentMode = .scaleAspectFit
        avatarButton.tintColor = .accent
        avatarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        avatarButton.layer.cornerRadius = 30
        avatarButton.layer.masksToBounds = true
        avatarButton.addTarget(self, action: #selector(didTapAvatarButton), for: .touchUpInside)
        
        collectionView.backgroundColor = .white
        collectionView.layer.masksToBounds = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        [headLabel, avatarButton, avatarActivityIndicator, collectionView, activityIndicator].forEach { view.addSubview($0)}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        activityIndicator.pin.center()
        
        headLabel.pin
            .top(view.pin.safeArea.top + 30)
            .left(view.pin.safeArea.left + 30)
            .sizeToFit()
        
        avatarButton.pin
            .top(view.pin.safeArea.top + 15)
            .right(view.pin.safeArea.left + 20)
            .height(60)
            .width(60)
        
        avatarActivityIndicator.pin
            .top(view.pin.safeArea.top + 15)
            .right(view.pin.safeArea.left + 20)
            .height(60)
            .width(60)
                
        collectionView.pin
            .below(of: headLabel)
            .marginTop(30)
            .horizontally(16)
            .bottom(6)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    public func pushGroupController(groupID : String) {
        let groupController = GroupController()
        groupController.groupID = groupID
        self.navigationController?.pushViewController(groupController, animated: true)
    }
    
    @objc
    func didTapAvatarButton() {
        let dialogMessage = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let chooseAction = UIAlertAction(title: "Выбрать аватар", style: .default, handler: {
            (action) -> Void in
            self.avatarActivityIndicator.startAnimating()
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        })
        
        let deleteAction = UIAlertAction(title: "Удалить аватар", style: .default, handler: { (action) -> Void in
            self.avatarActivityIndicator.startAnimating()
            self.database.setAvatar(avatarID: "") { [weak self] result in
                switch result {
                case .success(_):
                    self?.reloadAvatar()
                    self?.avatarActivityIndicator.stopAnimating()
                case .failure(_):
                    return
                }
            }
        })
        
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in
            self.avatarActivityIndicator.stopAnimating()
        }
        
        
        [cancelAction, chooseAction, deleteAction].forEach {
            dialogMessage.addAction($0)
        }
        
        self.present(dialogMessage, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        imageLoader.uploadImage(image) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let avatarID):
                self.database.setAvatar(avatarID: avatarID) { [weak self] result in
                    switch result {
                    case .success(_):
                        (self?.tabBarController as? MainTabBarController)?.reloadAvatars()
                        self?.reloadAvatar()
                        return
                    case .failure(_):
                        return
                    }
                }
            case .failure(_):
                return
            }
        }
    }
    
    func reloadGroups() {
        activityIndicator.startAnimating()
        groupDatabase.getGroups() { [weak self] result in
            switch result {
            case .success(let groups):
                self?.data = groups
                self?.collectionView.reloadData()
                self?.activityIndicator.stopAnimating()
            case .failure:
                return
            }
        }
    }
    
    func reloadAvatar() {
        avatarActivityIndicator.startAnimating()
        database.getAvatar() { [weak self] result in
            switch result {
            case .success(let avatar):
                if !avatar.isEmpty {
                    self?.imageLoader.downloadImage(avatar) { result in
                        switch result {
                        case .success(let image):
                            self?.avatarButton.setImage(image, for: .normal)
                            self?.avatarActivityIndicator.stopAnimating()
                        case .failure(_):
                            return
                        }
                    }
                } else {
                    self?.avatarButton.setImage(UIImage(named: "avatar"), for: .normal)
                    self?.avatarActivityIndicator.stopAnimating()
                }
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
    func didTapAddGroupButton() {
        didTapAddButton()
    }
    
    func didTapOpenGroupButton(groupID : String) {
        didTapOpenButton(groupID: groupID)
    }
    
}
