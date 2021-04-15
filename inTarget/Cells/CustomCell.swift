//
//  CustomCell.swift
//  inTarget
//
//  Created by Георгий on 15.04.2021.
//

import Foundation
import UIKit

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



