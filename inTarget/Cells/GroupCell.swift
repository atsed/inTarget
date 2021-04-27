//
//  GroupCell.swift
//  inTarget
//
//  Created by Desta on 27.04.2021.
//

import UIKit

protocol GroupCellDelegate: AnyObject {
    func didTapOpenButton(groupID : String)
}

class GroupCell: UICollectionViewCell {
    private var groupID : String = ""
    
    weak var delegate: GroupCellDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var underTasksCount: UILabel = {
        let underTasksCount = UILabel()
        underTasksCount.font = UIFont(name: "GothamPro", size: 15)
        underTasksCount.textColor = .black
        underTasksCount.translatesAutoresizingMaskIntoConstraints = false
        return underTasksCount
    }()

    
    private lazy var yearLabel: UILabel = {
        let date = UILabel()
        date.font = UIFont(name: "GothamPro", size: 11)
        date.textColor = .separator
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamPro", size: 24)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var openButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .accent
        return button
    }()

    
    private func setup() {
        [imageView, label, yearLabel, underTasksCount, openButton].forEach {
            contentView.addSubview($0)
        }
        
        backgroundColor = .lightAccent
        layer.cornerRadius = 18
        layer.masksToBounds = false
        
        openButton.addTarget(self, action: #selector(didTapOpenButton), for: .touchUpInside)
        setupConstraints()
        
        setupConstraints()
    }
    
    func configure(with task: Group) {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    private func setupConstraints() {
        
    }
    
    @objc
    func didTapOpenButton() {
        guard !groupID.isEmpty else {
            return
        }
        delegate?.didTapOpenButton(groupID: groupID)
    }
}

