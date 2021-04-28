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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamPro", size: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamPro", size: 14)
        label.textColor = .separator
        return label
    }()
    
    private lazy var underTasksLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamPro", size: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var lightUnderTasksLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamPro", size: 14)
        label.textColor = .separator
        return label
    }()
    
    private lazy var textContainer: UIView = {
        let container = UIView()
        return container
    }()
    
    lazy var openButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .accent
        return button
    }()

    
    private func setup() {
        [titleLabel, yearLabel, underTasksLabel, lightUnderTasksLabel].forEach {
            textContainer.addSubview($0)
        }
        [imageView, textContainer, openButton].forEach {
            contentView.addSubview($0)
        }
        
        backgroundColor = .lightAccent
        layer.cornerRadius = 18
        layer.masksToBounds = false
        
        openButton.addTarget(self, action: #selector(didTapOpenButton), for: .touchUpInside)
        
        setupConstraints()
        
    }
    
    func configure(with group: Group) {
        titleLabel.text = group.title
        groupID = group.randomName
        
        let labelUnderTasks : String = underTasksString(value: group.underTasks.count)
        underTasksLabel.text = String(group.underTasks.count) + " " + labelUnderTasks
        
        //заменить строку ниже
        lightUnderTasksLabel.text = underTasksLabel.text
        
        let oldDAteFormatter = DateFormatter()
        oldDAteFormatter.dateFormat = "dd MM yyyy"
        guard let oldDate = oldDAteFormatter.date(from: group.date) else {
            return
        }
        let newDAteFormatter = DateFormatter()
        newDAteFormatter.dateFormat = "dd MMMM yyyy"
        let newDate = newDAteFormatter.string(from: oldDate)
        
        yearLabel.text = newDate
        
        InjectionHelper.imageLoader.downloadGroupImage(group.image) { [weak self] result in
            switch result {
            case .success(let image):
                self?.imageView.image = image
            case .failure:
                return
            }
        }
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    private func setupConstraints() {
        imageView.pin
            .left(10)
            .height(45)
            .width(45)
            .vCenter()
        
        textContainer.pin
            .right(of: imageView)
            .right(10)
            .marginLeft(10)
        
        underTasksLabel.pin
            .right()
            .height(16)
            .width(200)
        
        lightUnderTasksLabel.pin
            .below(of: underTasksLabel)
            .right()
            .marginTop(6)
            .height(15)
            .width(200)
        
        titleLabel.pin
            .left(of: underTasksLabel)
            .height(16)
            .width(200)
        
        yearLabel.pin
            .below(of: titleLabel)
            .left(of: lightUnderTasksLabel)
            .marginTop(6)
            .height(15)
            .width(200)
        
        textContainer.pin
            .wrapContent()
            .vCenter()
        
        openButton.pin
            .horizontally()
            .vertically()
    }
    
    @objc
    func didTapOpenButton() {
        guard !groupID.isEmpty else {
            return
        }
        delegate?.didTapOpenButton(groupID: groupID)
    }
}

extension GroupCell {
    func underTasksString(value: Int) -> String {

        var underTasksLabel: String = ""
        
        if value == 1 {
            underTasksLabel = "цель"
        }
        if value % 10 == 2 ||
                    value % 10 == 3 ||
                    value % 10 == 4 {
            underTasksLabel = "цели"
        }
        if value % 10 == 5 ||
                    value % 10 == 6 ||
                    value % 10 == 7 ||
                    value % 10 == 8 ||
                    value % 10 == 9 ||
                    value % 10 == 0 {
            underTasksLabel = "целей"
        }
        if value % 100 == 11 ||
                    value % 100 == 12 ||
                    value % 100 == 13 ||
                    value % 100 == 14 {
            underTasksLabel = "целей"
        }
        
        return underTasksLabel
    }
}
