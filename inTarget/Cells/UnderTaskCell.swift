//
//  UnderTaskCell.swift
//  inTarget
//
//  Created by Desta on 21.04.2021.
//

import UIKit

protocol UnderTaskCellDelegate: AnyObject {
    func didTapSelectButton(underTaskID: String, isCompleted: Bool)
}

class UnderTaskCell: UICollectionViewCell {
    private var isCompleted : Bool = false
    private var underTaskID : String = ""
    
    weak var delegate: UnderTaskCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var checkmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(.checkMarkFalse, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .accent
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamPro", size: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        let date = UILabel()
        date.font = UIFont(name: "GothamPro", size: 14)
        date.textColor = .separator
        return date
    }()
    
    private lazy var textContainer: UIView = {
        let container = UIView()
        return container
    }()
    
    private func setup() {
        [titleLabel, yearLabel].forEach {
            textContainer.addSubview($0)
        }
        [checkmarkButton, textContainer].forEach {
            contentView.addSubview($0)
        }
        
        backgroundColor = .lightAccent
        layer.cornerRadius = 18
        layer.masksToBounds = false
        
        checkmarkButton.addTarget(self, action: #selector(didTapCheckmarkButton), for: .touchUpInside)
        
        setupConstraints()
    }
    
    func configure(with underTask: UnderTask) {
        titleLabel.text = underTask.title
        
        let oldDAteFormatter = DateFormatter()
        oldDAteFormatter.dateFormat = "dd MM yyyy"
        guard let oldDate = oldDAteFormatter.date(from: underTask.date) else {
            return
        }
    
        underTaskID = underTask.randomName
        
        let newDAteFormatter = DateFormatter()
        newDAteFormatter.dateFormat = "dd MMMM yyyy"
        let newDate = newDAteFormatter.string(from: oldDate)
        
        yearLabel.text = newDate
    
        if underTask.isCompleted == true {
            isCompleted = true
            checkmarkButton.setImage(.checkMarkTrue, for: .normal)
        } else {
            isCompleted = false
            checkmarkButton.setImage(.checkMarkFalse, for: .normal)
        }
        
    }
    
    private func setupConstraints() {
        
        checkmarkButton.pin
            .left(10)
            .height(30)
            .width(30)
            .vCenter()
        
        textContainer.pin
            .right(of: checkmarkButton)
            .marginLeft(10)
        
        titleLabel.pin
            .top()
            .height(16)
            .width(200)
        
        yearLabel.pin
            .below(of: titleLabel)
            .marginTop(6)
            .height(15)
            .width(200)
        
        textContainer.pin
            .wrapContent()
            .vCenter()

    }
    
    @objc
    private func didTapCheckmarkButton() {
        if isCompleted == false {
            isCompleted = true
            delegate?.didTapSelectButton(underTaskID: underTaskID, isCompleted: isCompleted)
            checkmarkButton.setImage(.checkMarkTrue, for: .normal)
            return
        } else {
            isCompleted = false
            delegate?.didTapSelectButton(underTaskID: underTaskID, isCompleted: isCompleted)
            checkmarkButton.setImage(.checkMarkFalse, for: .normal)
            return
        }
    }
    
}
