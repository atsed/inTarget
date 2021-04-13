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
        while indexPath.row >= data.count {
            uniqueCell.setupSpecialCell()
            return uniqueCell
        }
            cell.data = data[indexPath.row]
            cell.setup()
        
        return cell
    }
}
class UniqueCell: UICollectionViewCell{
    
    private lazy var button: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "bmstu")
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        button.setImage(image, for: .normal)
        return button
    }()
    
    func setupSpecialCell(){
        contentView.addSubview(button)
        
        backgroundColor = .white
        layer.cornerRadius = 30
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 6.0, height: 10.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        
        setupConstraints()
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 100),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

        ])
    }
}
class CustomCell: UICollectionViewCell {
    
    var data: Task?
    
    private lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.trackTintColor = .white
        progressBar.progressTintColor = .accent
        progressBar.frame = CGRect(x: 20, y: 150, width: 100, height: 100)
        progressBar.setProgress(0.5, animated: true)
        return progressBar
    }()
    
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = data?.image
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var underTasksCount: UILabel = {
        let underTasksCount = UILabel()
        let labelUnderTasks : String = " подзадач"
        underTasksCount.text = String(data?.underTasks.count ?? 0) + labelUnderTasks
        underTasksCount.font = UIFont(name: "GothamPro", size: 15)
        underTasksCount.textColor = .black
        underTasksCount.translatesAutoresizingMaskIntoConstraints = false
        return underTasksCount
    }()

    
    private lazy var yearLabel: UILabel = {
        let date = UILabel()
        date.text = data?.date
        date.font = UIFont(name: "GothamPro", size: 11)
        date.textColor = .separator
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = data?.title
        label.font = UIFont(name: "GothamPro", size: 24)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    func setup() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(yearLabel)
        contentView.addSubview(underTasksCount)
        contentView.addSubview(progressBar)
        
        backgroundColor = .white
        layer.cornerRadius = 30
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 6.0, height: 10.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 200),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            yearLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -80),
            yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            underTasksCount.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -50),
            underTasksCount.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            underTasksCount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            underTasksCount.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -120),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}



