//
//  TargetsController.swift
//  inTarget
//
//  Created by Георгий on 06.04.2021.
//

import PinLayout
import UIKit

struct CustomData{
    var title: String
    var image: UIImage
    var year: String
    var underTask: Int
}

final class TargetsController: UIViewController {
    
    private let headLabel: UILabel = {
        let headLabel = UILabel()
        headLabel.text = "Цели"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
        return headLabel
    }()
    
    let data = [
        CustomData(title: "IOS курс", image: #imageLiteral(resourceName: "artur"), year: "2021", underTask: 10),
        CustomData(title: "МГТУ", image: #imageLiteral(resourceName: "bmstu"), year: "2021", underTask: 8)
    ]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")

        return cv
    }()
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headLabel.pin
            .top(view.pin.safeArea.top + 30)
            .left(view.pin.safeArea.left + 30)
            .sizeToFit()
            .hCenter()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(headLabel)
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
}

extension TargetsController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/1.1, height: collectionView.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.data = data[indexPath.row]
        cell.setup()
        return cell
    }
}

class CustomCell: UICollectionViewCell {
    
    var data: CustomData?
    
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
    
    private lazy var underTaskCount: UILabel = {
        let underTaskCount = UILabel()
        let labelUnderTask : String = " подзадач"
        underTaskCount.text = String(data?.underTask ?? 0) + labelUnderTask
        underTaskCount.font = UIFont(name: "GothamPro", size: 10)
        underTaskCount.textColor = .black
        underTaskCount.translatesAutoresizingMaskIntoConstraints = false
        return underTaskCount
    }()

    
    private lazy var yearLabel: UILabel = {
        let year = UILabel()
        year.text = data?.year
        year.font = UIFont(name: "GothamPro", size: 11)
        year.textColor = .gray
        year.translatesAutoresizingMaskIntoConstraints = false
        return year
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
        contentView.addSubview(underTaskCount)
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
            
            underTaskCount.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -50),
            underTaskCount.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            underTaskCount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            underTaskCount.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -120),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}



