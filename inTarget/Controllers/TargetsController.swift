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
    
    
    
    let data = [
        Task(title: "IOS курс", image: #imageLiteral(resourceName: "artur"), date: "10 мая 2021"),
        Task(title: "МГТУ", image: #imageLiteral(resourceName: "bmstu"), date: "2 апреля 2021")
    ]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(headLabel)
        
        headLabel.text = "Цели"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
        
        collectionView.backgroundColor = .white
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 170).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.5).isActive = true
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
    }
    
    @objc func didTapAddButton() {
        tabBarController?.selectedIndex = 1
    }
}

extension TargetsController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/1.1, height: collectionView.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        let uniqueCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uniqueCell", for: indexPath) as! UniqueCell
        uniqueCell.button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        while indexPath.row >= data.count {
            uniqueCell.setupSpecialCell()
            return uniqueCell
        }
            cell.data = data[indexPath.row]
            cell.setup()
        
        return cell
    }

}
