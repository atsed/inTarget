//
//  NewUnderTaskCell.swift
//  inTarget
//
//  Created by Desta on 21.04.2021.
//

import UIKit

protocol NewUnderTaskCellDelegate: AnyObject {
    func didTapActionButton()
}

public class NewUnderTaskCell: UICollectionViewCell {
    
    weak var delegate: NewUnderTaskCellDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus.circle.fill")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .accent
        return button
    }()
    

    private func setup() {
        contentView.addSubview(addButton)
        
        backgroundColor = .lightAccent
        layer.cornerRadius = 18
        layer.masksToBounds = false
        
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        setupConstraints()
    }
    
    @objc
    func didTapAddButton() {
        delegate?.didTapActionButton()
    }
    
    private func setupConstraints() {
        addButton.pin
            .top(16)
            .left(16)
            .bottom(16)
            .sizeToFit()
    }
}
