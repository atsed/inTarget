//
//  TargetsController.swift
//  inTarget
//
//  Created by Георгий on 06.04.2021.
//

import UIKit
import PinLayout

final class TargetsController: UIViewController {
    private let headLabel = UILabel()
    private let groupsLabel = UILabel()
    
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
    
    var data: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        reloadTasks()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        headLabel.text = "Цели"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
        
        groupsLabel.text = "Групповые цели"
        groupsLabel.textColor = .black
        groupsLabel.font = UIFont(name: "GothamPro", size: 24)
        
        tasksCollectionView.backgroundColor = .background
        tasksCollectionView.delegate = self
        tasksCollectionView.dataSource = self
        
        [tasksCollectionView, headLabel, groupsLabel].forEach { view.addSubview($0) }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headLabel.pin
            .top(view.pin.safeArea.top + 30)
            .left(view.pin.safeArea.left + 30)
            .sizeToFit()
        
        tasksCollectionView.pin
            .below(of: headLabel)
            .marginTop(30)
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
            .bottom()
    }
    
    @objc
    func didTapAddButton() {
        (self.tabBarController as? MainTabBarController)?.reloadVC2(valueSegmCon: 0)
        tabBarController?.selectedIndex = 1
    }
    
    @objc
    func didTapTaskOpenButton(taskID : String) {
        (self.tabBarController as? MainTabBarController)?.openGoalVC4(with: taskID)
    }
    
    public func reloadTasks() {
        database.getTasks { result in
            switch result {
            case .success(let tasks):
                self.data = tasks
                self.tasksCollectionView.reloadData()
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
        return CGSize(width: tasksCollectionView.frame.width/1.1, height: 177)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == data.count {
            guard let newTaskCell = tasksCollectionView.dequeueReusableCell(withReuseIdentifier: "NewTaskCell", for: indexPath) as? NewTaskCell else {
                return UICollectionViewCell()
            }
            
            newTaskCell.delegate = self
            return newTaskCell
        }
        
        guard let cell = tasksCollectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            return UICollectionViewCell()
        }
    
        let task = data[indexPath.row]
        cell.configure(with: task)
        cell.delegate = self
        
        return cell
    }

}

extension TargetsController: TaskCellDelegate, NewTaskCellDelegate {
    func didTapOpenTaskButton(taskID : String) {
        didTapTaskOpenButton(taskID: taskID)
    }
    
    func didTapActionButton() {
        didTapAddButton()
    }
}
