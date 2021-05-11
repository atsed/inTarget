//
//  MemberCell.swift
//  inTarget
//
//  Created by Desta on 06.05.2021.
//


import UIKit

class MemberCell: UICollectionViewCell {
    private var userID : String = ""
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamPro", size: 16)
        label.textColor = .black
        return label
    }()
    
    private func setup() {
        [avatarView, nameLabel].forEach {
            contentView.addSubview($0)
        }
        
        backgroundColor = .white
        layer.cornerRadius = 18
        layer.masksToBounds = false
        
}
    
    func configure(with user: User) {
        nameLabel.text = user.name + " " + user.surName
        if !user.avatar.isEmpty {
            InjectionHelper.imageLoader.downloadImageByID(user.uid, user.avatar) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.avatarView.image = image
                case .failure:
                    return
                }
            }
        }
        
        avatarView.layer.cornerRadius = 45/2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarView.pin
            .left(10)
            .height(45)
            .width(45)
            .vCenter()
        
        nameLabel.pin
            .right(of: avatarView)
            .marginLeft(15)
            .vCenter()
            .sizeToFit()

    }
    
}
