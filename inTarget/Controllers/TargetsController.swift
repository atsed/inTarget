//
//  TargetsController.swift
//  inTarget
//
//  Created by Георгий on 06.04.2021.
//

import UIKit
import PinLayout

final class TargetsController: UIViewController {
    private let tv = UITableView()
    private let headLabel = UILabel()
    private let avatarImage = UIImageView()
    private let groupsLabel = UILabel()
    private let avatarActivityIndicator = UIActivityIndicatorView()
    private let tasksActivityIndicator = UIActivityIndicatorView()
    private let groupsActivityIndicator = UIActivityIndicatorView()
    private let refreshScrollView = UIScrollView()
    
    private let tasksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(TaskCell.self, forCellWithReuseIdentifier: "TaskCell")
        cv.register(NewTaskCell.self, forCellWithReuseIdentifier: "NewTaskCell")
        return cv
    }()
    
    private let groupsCollectionView: UICollectionView = {
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
    
    var tasks: [Task] = []
    
    var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarActivityIndicator.hidesWhenStopped = true
        tasksActivityIndicator.hidesWhenStopped = true
        groupsActivityIndicator.hidesWhenStopped = true
        
        setup()
        reloadAvatar()
        reloadTasks()
        reloadGroups()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        tasksActivityIndicator.startAnimating()
        groupsActivityIndicator.startAnimating()
        
        headLabel.text = "Цели"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
        
        avatarImage.image = UIImage(named: "avatar")
        avatarImage.backgroundColor = .accent
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.clipsToBounds = true
        
        groupsLabel.text = "Групповые цели"
        groupsLabel.textColor = .black
        groupsLabel.font = UIFont(name: "GothamPro", size: 24)
        
        tasksCollectionView.backgroundColor = .background
        tasksCollectionView.delegate = self
        tasksCollectionView.dataSource = self
        
        groupsCollectionView.backgroundColor = .background
        groupsCollectionView.delegate = self
        groupsCollectionView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadAll), for: .valueChanged)
        
        refreshScrollView.refreshControl = refreshControl
        
        [tasksCollectionView, tasksActivityIndicator, groupsLabel, groupsCollectionView, groupsActivityIndicator].forEach { refreshScrollView.addSubview($0) }
        [headLabel, avatarImage, avatarActivityIndicator, refreshScrollView].forEach { view.addSubview($0) }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headLabel.pin
            .top(view.pin.safeArea.top + 30)
            .left(view.pin.safeArea.left + 30)
            .sizeToFit()
        
        avatarImage.pin
            .top(view.pin.safeArea.top + 15)
            .right(view.pin.safeArea.left + 20)
            .height(60)
            .width(60)
        
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        
        avatarActivityIndicator.pin
            .top(view.pin.safeArea.top + 15)
            .right(view.pin.safeArea.left + 20)
            .height(60)
            .width(60)
        
        refreshScrollView.pin
            .below(of: avatarImage)
            .bottom()
            .horizontally()
        
        tasksCollectionView.pin
            .below(of: avatarImage)
            .marginTop(10)
            .horizontally()
            .height(220)
        
        tasksActivityIndicator.pin
            .below(of: avatarImage)
            .marginTop(10)
            .horizontally()
            .height(220)
        
        groupsLabel.pin
            .below(of: tasksCollectionView)
            .marginTop(30)
            .left(view.pin.safeArea.left + 30)
            .sizeToFit()
        
        groupsCollectionView.pin
            .below(of: groupsLabel)
            .marginTop(30)
            .horizontally(16)
            .bottom(6)
        
        groupsActivityIndicator.pin
            .below(of: groupsLabel)
            .marginTop(30)
            .horizontally(16)
            .bottom(6)
    }
    
    @objc
    func didTapActionTaskButton() {
        (self.tabBarController as? MainTabBarController)?.reloadVC2(valueSegmCon: 0)
        tabBarController?.selectedIndex = 1
    }
    
    @objc
    func didTapActionGroupButton() {
        (self.tabBarController as? MainTabBarController)?.reloadVC2(valueSegmCon: 1)
        tabBarController?.selectedIndex = 1
    }
    
    @objc
    func didTapTaskOpenButton(taskID : String) {
        (self.tabBarController as? MainTabBarController)?.openGoalVC4(with: taskID)
    }
    
    @objc
    func didTapGroupOpenButton(groupID : String) {
        (self.tabBarController as? MainTabBarController)?.openGoalVC3(with: groupID)
    }
    
    @objc
    func reloadAll() {
        reloadTasks()
        reloadGroups()
    }
    
    private func reloadTasks() {
        self.refreshScrollView.refreshControl?.beginRefreshing()
        self.tasksActivityIndicator.startAnimating()
        database.getTasks { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
                self?.tasksCollectionView.reloadData()
                self?.tasksActivityIndicator.stopAnimating()
                self?.refreshScrollView.refreshControl?.endRefreshing()
            case .failure:
                self?.refreshScrollView.refreshControl?.endRefreshing()
                return
            }
        }
    }
    
    private func reloadGroups() {
        self.refreshScrollView.refreshControl?.beginRefreshing()
        self.groupsActivityIndicator.startAnimating()
        groupDatabase.getGroups() { [weak self] result in
            switch result {
            case .success(let groups):
                self?.groups = groups
                self?.groupsCollectionView.reloadData()
                self?.groupsActivityIndicator.stopAnimating()
                self?.refreshScrollView.refreshControl?.endRefreshing()
            case .failure:
                self?.refreshScrollView.refreshControl?.endRefreshing()
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
                            self?.avatarImage.image = image
                            self?.avatarActivityIndicator.stopAnimating()
                        case .failure(_):
                            return
                        }
                    }
                } else {
                    self?.avatarImage.image = UIImage(named: "avatar")
                    self?.avatarActivityIndicator.stopAnimating()
                }
            case .failure:
                return
            }
        }
    }
}

extension TargetsController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.tasksCollectionView {
            if indexPath.last == tasks.count {
                return CGSize(width: 177, height: 177)
            } else {
                return CGSize(width: collectionView.frame.width/1.1, height: 177)
            }
        }
        
        else {
            return CGSize(width: groupsCollectionView.frame.width, height: 64)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.tasksCollectionView {
            return tasks.count + 1
        }
        else {
            return groups.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.tasksCollectionView {
            if indexPath.row == tasks.count {
                guard let newTaskCell = tasksCollectionView.dequeueReusableCell(withReuseIdentifier: "NewTaskCell", for: indexPath) as? NewTaskCell else {
                    return UICollectionViewCell()
                }
                newTaskCell.delegate = self
                return newTaskCell
            }
            
            guard let cell = tasksCollectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
                return UICollectionViewCell()
            }
            
            let task = tasks[indexPath.row]
            cell.configure(with: task)
            cell.delegate = self
            
            return cell
            
        }
        else {
            if indexPath.row == groups.count {
                guard let newGroupCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewGroupCell", for: indexPath) as? NewGroupCell else {
                    return UICollectionViewCell()
                }
                newGroupCell.delegate = self
                return newGroupCell
            }
            
            guard let groupCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as? GroupCell else {
                return UICollectionViewCell()
            }
            
            let group = groups[indexPath.row]
            groupCell.configure(with: group)
            groupCell.delegate = self
            
            return groupCell
        }
    }
    
}

extension TargetsController: TaskCellDelegate, NewTaskCellDelegate, GroupCellDelegate, NewGroupCellDelegate {
    
    func didTapOpenGroupButton(groupID: String) {
        didTapGroupOpenButton(groupID: groupID)
    }
    
    func didTapOpenTaskButton(taskID : String) {
        didTapTaskOpenButton(taskID: taskID)
    }
    
    func didTapAddTaskButton() {
        didTapActionTaskButton()
    }
    
    func didTapAddGroupButton() {
        didTapActionGroupButton()
    }
}
