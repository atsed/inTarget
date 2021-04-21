//
//  TargetsController.swift
//  inTarget
//
//  Created by Георгий on 06.04.2021.
//

import PinLayout
import UIKit

final class TargetsController: UIViewController {
    private let headLabel = UILabel()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.register(UniqueCell.self, forCellWithReuseIdentifier: "uniqueCell")
        return cv
    }()
    
    private let dataBase = DatabaseModel()
    
    var data: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        reloadTasks()
    }
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(headLabel)
        
        headLabel.text = "Цели"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
        
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 30
        collectionView.layer.masksToBounds = false
        collectionView.delegate = self
        collectionView.dataSource = self
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
            .horizontally()
            .height(177)
    }
    
    @objc func didTapAddButton() {
        tabBarController?.selectedIndex = 1
    }
    
    public func reloadTasks() {
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
}

extension TargetsController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/1.1, height: 177)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == data.count {
            guard let uniqueCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uniqueCell", for: indexPath) as? UniqueCell else {
                return UICollectionViewCell()
            }
            
            uniqueCell.delegate = self
            return uniqueCell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCell else {
            return UICollectionViewCell()
        }
    
        let task = data[indexPath.row]
        cell.configure(with: task)
        
        return cell
    }

}

extension TargetsController: UniqueCellDelegate {
    func didTapActionButton() {
        didTapAddButton()
    }
}
