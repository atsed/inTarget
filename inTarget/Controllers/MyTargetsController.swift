//
//  MyTargetsController.swift
//  inTarget
//
//  Created by Георгий on 06.04.2021.
//

import UIKit
import PinLayout

final class MyTargetsController: UIViewController {
    private let headLabel = UILabel()
    private let avatarImage = UIImageView()
    private let avatarActivityIndicator = UIActivityIndicatorView()
    private let activityIndicator = UIActivityIndicatorView()
    private let refreshScrollView = UIScrollView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.register(TaskCell.self, forCellWithReuseIdentifier: "TaskCell")
        cv.register(NewTaskCell.self, forCellWithReuseIdentifier: "NewTaskCell")
        return cv
    }()
    
    var data: [Task] = []
    private let database = DatabaseModel()
    private let imageLoader = InjectionHelper.imageLoader
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarActivityIndicator.hidesWhenStopped = true
        activityIndicator.hidesWhenStopped = true
        reloadAvatar()
        reloadTasks()
        
        view.backgroundColor = .white
        
        headLabel.text = "Мои цели"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
        
        avatarImage.image = UIImage(named: "avatar")
        avatarImage.backgroundColor = .accent
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.clipsToBounds = true
        
        collectionView.backgroundColor = .white
        collectionView.layer.masksToBounds = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTasks), for: .valueChanged)
        
        refreshScrollView.refreshControl = refreshControl
        
        [collectionView, activityIndicator].forEach { refreshScrollView.addSubview($0) }
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
        
        collectionView.pin
            .below(of: headLabel)
            .marginTop(30)
            .horizontally()
            .bottom(6)
        
        activityIndicator.pin
            .below(of: headLabel)
            .marginTop(30)
            .horizontally()
            .bottom(6)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    public func pushMyTargetController(taskName : String) {
        let myTargetController = MyTargetController()
        myTargetController.taskName = taskName
        self.navigationController?.pushViewController(myTargetController, animated: true)
    }
    
    @objc
    func reloadTasks() {
        self.refreshScrollView.refreshControl?.beginRefreshing()
        activityIndicator.startAnimating()
        database.getTasks { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.data = tasks
                self?.collectionView.reloadData()
                self?.activityIndicator.stopAnimating()
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
    
    @objc
    func didTapOpenButton(taskID : String) {
        (self.tabBarController as? MainTabBarController)?.openGoalVC4(with: taskID)
    }
    
    @objc
    func didTapActionTaskButton() {
        (self.tabBarController as? MainTabBarController)?.reloadVC2(valueSegmCon: 0)
        tabBarController?.selectedIndex = 1
    }
}



extension MyTargetsController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.last == data.count {
            return CGSize(width: collectionView.frame.width/1.1, height: 100)
        } else {
            return CGSize(width: collectionView.frame.width/1.1, height: 177)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == data.count {
            guard let newTaskCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewTaskCell", for: indexPath) as? NewTaskCell else {
                return UICollectionViewCell()
            }
            
            newTaskCell.delegate = self
            return newTaskCell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            return UICollectionViewCell()
        }
    
        let task = data[indexPath.row]
        cell.configure(with: task)
        cell.delegate = self
        
        return cell
    }
}

extension MyTargetsController: TaskCellDelegate, NewTaskCellDelegate {
    func didTapOpenTaskButton(taskID : String) {
        didTapOpenButton(taskID: taskID)
    }
    
    func didTapAddTaskButton() {
        didTapActionTaskButton()
    }
}

