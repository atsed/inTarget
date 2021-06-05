//
//  GroupController.swift
//  inTarget
//
//  Created by Desta on 28.04.2021.
//

import UIKit
import PinLayout

final class GroupController: UIViewController {
    private let membersTitle = UILabel()
    private let underTasksTitle = UILabel()
    private let scrollView = UIScrollView()
    private let membersActivityIndicator = UIActivityIndicatorView()
    private let underTaskActivityIndicator = UIActivityIndicatorView()
    
    private let groupDatabase = GroupDatabaseModel()
    private let database = DatabaseModel()
    
    private let membersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(MemberCell.self, forCellWithReuseIdentifier: "MemberCell")
        cv.register(NewMemberCell.self, forCellWithReuseIdentifier: "NewMemberCell")
        return cv
    }()
    
    private let underTaskCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(UnderTaskCell.self, forCellWithReuseIdentifier: "UnderTaskCell")
        cv.register(NewUnderTaskCell.self, forCellWithReuseIdentifier: "NewUnderTaskCell")
        return cv
    }()
    
    private var kbFrameSize : CGRect = .zero
    var groupID = ""
    var users: [User] = []
    var group = Group(randomName: "", title: "", date: "", image: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        membersActivityIndicator.hidesWhenStopped = true
        underTaskActivityIndicator.hidesWhenStopped = true
        checkKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        loadGroup()
        
        view.backgroundColor = .white
        
        membersTitle.text = "Участники"
        underTasksTitle.text = "Цели"
        [membersTitle, underTasksTitle].forEach {
            ($0).font = UIFont(name: "GothamPro", size: 18)
            ($0).textAlignment = .left
            ($0).textColor = .black
        }
        
        [membersCollectionView, underTaskCollectionView].forEach {
            ($0).backgroundColor = .white
            ($0).layer.masksToBounds = true
            ($0).delegate = self
            ($0).dataSource = self
        }
        
        scrollView.keyboardDismissMode = .onDrag
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadGroup), for: .valueChanged)
        
        scrollView.refreshControl = refreshControl
        
        [underTaskCollectionView, underTaskActivityIndicator].forEach { scrollView.addSubview($0) }
        [membersTitle, membersCollectionView, membersActivityIndicator, underTasksTitle, scrollView].forEach { view.addSubview($0) }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        membersTitle.pin
            .top(view.pin.safeArea.top + 10)
            .horizontally(16)
            .sizeToFit()
        
        membersCollectionView.pin
            .below(of: membersTitle)
            .marginTop(20)
            .horizontally(16)
            .height(162)
        
        membersActivityIndicator.pin
            .below(of: membersTitle)
            .marginTop(20+81)
            .hCenter()
        
        underTasksTitle.pin
            .below(of: membersCollectionView)
            .marginTop(10)
            .horizontally(16)
            .sizeToFit()
        
        scrollView.pin
            .below(of: underTasksTitle)
            .marginTop(20)
            .horizontally()
            .bottom()
            .marginBottom(10)
        
        underTaskCollectionView.pin
            .top()
            .horizontally(16)
            .bottom()
        
        underTaskActivityIndicator.pin
            .center()
        
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapGroupDeleteButton))
        
        navigationItem.rightBarButtonItem?.tintColor = .accent
    }
    
    @objc
    func loadGroup() {
        guard !groupID.isEmpty else {
            return
        }
        underTaskActivityIndicator.startAnimating()
        groupDatabase.getGroup(groupID: groupID) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let group):
                self.group = group
                self.navigationController?.navigationBar.backItem?.backButtonTitle = group.title
                self.underTaskCollectionView.reloadData()
                self.loadUsers()
                self.underTaskActivityIndicator.stopAnimating()
            case .failure:
                return
            }
        }
    }
    
    func loadUsers() {
        membersActivityIndicator.startAnimating()
        users.removeAll()
        for member in group.members {
            database.getUser(userID: member) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.users.append(user)
                    self?.membersCollectionView.reloadData()
                    self?.membersActivityIndicator.stopAnimating()
                    self?.scrollView.refreshControl?.endRefreshing()
                case .failure(_):
                    return
                }
            }
        }
    }
    
    @objc
    private func didTapActionMemberButton(email : String) {
        membersActivityIndicator.startAnimating()
        database.getUserUID(email: email) { [weak self] result in
            switch result {
            case .success(let userUID):
                self?.database.addGroup(groupID: self?.groupID ?? "", userUID: userUID) { result in
                    switch result {
                    case .success(_):
                        self?.groupDatabase.addMember(groupID: self?.groupID ?? "", userUID: userUID) { result in
                            switch result {
                            case .success(_):
                                self?.loadGroup()
                                return
                            case .failure(_):
                                self?.membersActivityIndicator.stopAnimating()
                                return
                            }
                        }
                        return
                    case .failure(_):
                        return
                    }
                    
                }
            case .failure(_):
                self?.membersActivityIndicator.stopAnimating()
                self?.showAlert()
                return
            }
            
        }
    }
    
    func showAlert() {
        let dialogMessage = UIAlertController(title: nil, message: "Пользователь не найден", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ок", style: .cancel)
        
        dialogMessage.addAction(cancelAction)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @objc
    private func didTapAddGroupUnderTaskButton(title: String, date: String) {
        underTaskActivityIndicator.startAnimating()
        groupDatabase.createUnderTask(groupID, title, date) { [weak self] result in
            switch result {
            case .success(_):
                self?.loadGroup()
                (self?.tabBarController as? MainTabBarController)?.reloadTasks()
            case .failure(_):
                self?.underTaskActivityIndicator.stopAnimating()
                return
            }
        }
    }
    
    @objc
    private func didTapCompletedButton(underTaskID: String, isCompleted: Bool) {
        underTaskActivityIndicator.startAnimating()
        groupDatabase.selctCheckmark(groupID: groupID, underTaskID: underTaskID, isCompleted: isCompleted) { [weak self] result in
            switch result {
            case .success(_):
                self?.loadGroup()
                (self?.tabBarController as? MainTabBarController)?.reloadTasks()
            case .failure(_):
                self?.underTaskActivityIndicator.stopAnimating()
                return
            }
        }
    }
    
    @objc
    private func didTapUnderTaskDeleteButton(underTaskID: String) {        
        let dialogMessage = UIAlertController(title: "Предупреждение", message: "Вы действительно хотите удалить подзадачу?", preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "Удалить", style: .default, handler: { (action) -> Void in
            self.underTaskActivityIndicator.startAnimating()
            self.groupDatabase.deleteGroupUnderTask(groupID: self.groupID, underTaskID: underTaskID) { [weak self] result in
                switch result {
                case .success(_):
                    self?.loadGroup()
                    (self?.tabBarController as? MainTabBarController)?.reloadTasks()
                    return
                case .failure(_):
                    self?.underTaskActivityIndicator.stopAnimating()
                    return
                }
            }
        })
        
        okAction.setValue(UIColor.red, forKey: "titleTextColor")

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        dialogMessage.addAction(cancelAction)
        dialogMessage.addAction(okAction)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @objc
    private func didTapGroupDeleteButton() {
        let dialogMessage = UIAlertController(title: "Предупреждение", message: "Вы действительно хотите удалить группу?", preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "Удалить", style: .default, handler: { (action) -> Void in
            self.underTaskActivityIndicator.startAnimating()
            self.groupDatabase.deleteGroup(groupID: self.groupID) { [weak self] result in
                switch result {
                case .success(_):
                    self?.navigationController?.popToRootViewController(animated: true)
                    (self?.tabBarController as? MainTabBarController)?.reloadTasks()
                    return
                case .failure(_):
                    return
                }
            }
        })
        
        okAction.setValue(UIColor.red, forKey: "titleTextColor")

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        dialogMessage.addAction(cancelAction)
        dialogMessage.addAction(okAction)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    func checkKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func kbDidShow(_ notification : Notification) {
        let userInfo = notification.userInfo
        let numberOfItems = underTaskCollectionView.numberOfItems(inSection: 0)
        kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width,
                                        height: self.scrollView.bounds.height + kbFrameSize.height)
        if numberOfItems > 3 {
            scrollView.contentOffset = CGPoint(x: 0,
                                               y: kbFrameSize.height - (self.tabBarController?.tabBar.bounds.height ?? 0))
        }

    }
    
    @objc
    func kbDidHide() {
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.scrollView.bounds.height)
    }
}

extension GroupController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.membersCollectionView {
            return CGSize(width: collectionView.frame.width, height: 44)
        } else {
            return CGSize(width: collectionView.frame.width, height: 64)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.membersCollectionView {
            return users.count + 1
        } else {
            return group.underTasks.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.membersCollectionView {
            if indexPath.row == users.count {
                guard let newMemberCell = membersCollectionView.dequeueReusableCell(withReuseIdentifier: "NewMemberCell", for: indexPath) as? NewMemberCell else {
                    return UICollectionViewCell()
                }
                
                newMemberCell.delegate = self
                return newMemberCell
            }
            
            guard let cell = membersCollectionView.dequeueReusableCell(withReuseIdentifier: "MemberCell", for: indexPath) as? MemberCell else {
                return UICollectionViewCell()
            }
            
            let user = users[indexPath.row]
            cell.configure(with: user)
            
            return cell
        } else {
            if indexPath.row == group.underTasks.count {
                guard let newUnderTaskCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewUnderTaskCell", for: indexPath) as? NewUnderTaskCell else {
                    return UICollectionViewCell()
                }
                
                newUnderTaskCell.delegate = self
                return newUnderTaskCell
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnderTaskCell", for: indexPath) as? UnderTaskCell else {
                return UICollectionViewCell()
            }
            
            let underTask = group.underTasks[indexPath.row]
            cell.configure(with: underTask)
            cell.delegate = self
            
            return cell
        }
    }
}

extension GroupController: NewMemberCellDelegate, UnderTaskCellDelegate, NewUnderTaskCellDelegate {
    
    
    func didTapAddMemberButton(email: String) {
        didTapActionMemberButton(email: email)
    }
    
    func didTapSelectButton(underTaskID: String, isCompleted: Bool) {
        didTapCompletedButton(underTaskID: underTaskID, isCompleted: isCompleted)
    }
    
    func didTapDeleteButton(underTaskID: String) {
        didTapUnderTaskDeleteButton(underTaskID: underTaskID)
    }
    
    func didTapAddUnderTaskButton(title: String, date: String) {
        didTapAddGroupUnderTaskButton(title: title, date: date)
    }
}
