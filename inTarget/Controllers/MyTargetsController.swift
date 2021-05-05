//
//  MyTargetsController.swift
//  inTarget
//
//  Created by Георгий on 06.04.2021.
//

import UIKit
import PinLayout

final class MyTargetsController: UIViewController {
    private let logoutButton = UIButton()
    private let headLabel = UILabel()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.register(TaskCell.self, forCellWithReuseIdentifier: "myTargetsControllerCell")
        return cv
    }()
    
    let image = UIImage(named: "exit")?.withTintColor(.accent)
    var data: [Task] = []
    private let dataBase = DatabaseModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        reloadTasks()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headLabel.pin
            .top(view.pin.safeArea.top + 30)
            .left(view.pin.safeArea.left + 30)
            .sizeToFit()
        
        logoutButton.pin
            .top(view.pin.safeArea.top + 25)
            .right(view.pin.safeArea.left + 30)
            .size(CGSize(width: 25, height: 25))
        
        collectionView.pin
            .below(of: headLabel)
            .marginTop(30)
            .horizontally()
            .bottom(view.pin.safeArea.bottom + 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    public func pushMyTargetController(taskName : String) {
        let myTargetController = MyTargetController()
        myTargetController.taskName = taskName
        self.navigationController?.pushViewController(myTargetController, animated: true)
    }
    
    public func setup() {
        
        view.backgroundColor = .white
        view.addSubview(logoutButton)
        view.addSubview(collectionView)
        view.addSubview(headLabel)
        
      
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        logoutButton.setImage(image, for: .normal)
        logoutButton.contentVerticalAlignment = .fill
        logoutButton.contentHorizontalAlignment = .fill
        logoutButton.tintColor = .accent
        logoutButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        logoutButton.imageView?.layer.cornerRadius = logoutButton.bounds.height/2.0
        
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 30
        collectionView.layer.masksToBounds = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        headLabel.text = "Мои цели"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
    }
    
    func reloadTasks() {
        dataBase.getTasks { result in
            switch result {
            case .success(let tasks):
                self.data = tasks
                self.collectionView.reloadData()
            case .failure:
                return
            }
        }
    }
    

    @objc
    func didTapLogoutButton() {
        let dialogMessage = UIAlertController(title: "Предупреждение", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Выйти", style: .default, handler: { (action) -> Void in
            
            UserDefaults.standard.setValue(false, forKey: "isAuth")
            let authViewController = AuthViewController()
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: false, completion: nil)
        })
        
        okAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        dialogMessage.addAction(cancelAction)
        dialogMessage.addAction(okAction)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @objc
    func didTapOpenButton(taskID : String) {
        (self.tabBarController as? MainTabBarController)?.openGoalVC4(with: taskID)
    }
}



extension MyTargetsController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/1.1, height: 177)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myTargetsControllerCell", for: indexPath) as? TaskCell else {
            return UICollectionViewCell()
        }
        let task = data[indexPath.row]
        cell.configure(with: task)
        cell.delegate = self
        
        return cell
    }

}

extension MyTargetsController: TaskCellDelegate {
    func didTapOpenTaskButton(taskID : String) {
        didTapOpenButton(taskID: taskID)
    }
}

