//
//  NewGroupCell.swift
//  inTarget
//
//  Created by Desta on 27.04.2021.
//

import UIKit

protocol NewGroupCellDelegate: AnyObject {
    func didTapAddGroupButton()
}

public class NewGroupCell: UICollectionViewCell {
    
    weak var delegate: NewGroupCellDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        
        button.setTitle("Создать группу", for: .normal)
        button.titleLabel?.font = UIFont(name: "GothamPro", size: 16)
        button.setTitleColor(.accent, for: .normal)
        //button.backgroundColor = .accent
        button.setTitleColor(.lightGray, for: .selected)
        button.layer.masksToBounds = true
        
        return button
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        button.pin
            .vertically()
            .horizontally()
    }

    private func setup() {
        contentView.addSubview(button)

        backgroundColor = .lightAccent
        layer.cornerRadius = 18
        layer.masksToBounds = false
        
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        //setupConstraints()
    }
    
    @objc
    func didTapAddButton() {
        delegate?.didTapAddGroupButton()
    }
}
