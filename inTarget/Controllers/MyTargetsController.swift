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
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "myTargetsControllerCell")
        return cv
    }()
    let image = UIImage(systemName: "person.fill.xmark")
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
            .top(view.pin.safeArea.top + 30)
            .right(view.pin.safeArea.left + 30)
            .size(CGSize(width: 40, height: 30))
        
        collectionView.pin
                   .below(of: logoutButton)
                   .marginTop(30)
                   .horizontally()
                   .height(177)
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
        collectionView.layer.masksToBounds = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        headLabel.text = "Цели"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
    }
    
    func reloadTasks() {
        dataBase.getTasks { result in
            switch result {
            case .success(let tasks):
                self.data = tasks
                print("DATA: \(String(describing: self.data))")
                self.collectionView.reloadData()
            case .failure:
                return
            }
        }
    }
    

    @objc
    func didTapLogoutButton() {
        UserDefaults.standard.setValue(false, forKey: "isAuth")
        
        let dialogMessage = UIAlertController(title: "Предупреждение", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        
        
        let ok = UIAlertAction(title: "Выйти", style: .default, handler: { (action) -> Void in
            UserDefaults.standard.setValue(false, forKey: "isAuth")
            let authViewController = AuthViewController()
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: false, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "Назад", style: .cancel) { (action) -> Void in
            
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    
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
        
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myTargetsControllerCell", for: indexPath) as? CustomCell else {
            return UICollectionViewCell()
        }
        let task = data[indexPath.row]
        cell.configure(with: task)
        return cell
    }

}


