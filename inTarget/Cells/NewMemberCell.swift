//
//  NewMemberCell.swift
//  inTarget
//
//  Created by Desta on 06.05.2021.
//

import UIKit

protocol NewMemberCellDelegate: AnyObject {
    func didTapAddMemberButton(email: String)
}

public class NewMemberCell: UICollectionViewCell {
    private var userID : String = ""
    
    weak var delegate: NewMemberCellDelegate?
        
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus.circle.fill")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .accent
        return button
    }()
    
    private lazy var newMemberEmailField : UITextField =  {
        let textField = UITextField()
        textField.placeholder = "Email пользователя"
        textField.borderStyle = .none
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private func setup() {
        [addButton, newMemberEmailField].forEach {
            contentView.addSubview($0)
        }
        
        backgroundColor = .lightAccent
        layer.cornerRadius = 18
        layer.masksToBounds = false
        
        addButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        addButton.pin
            .right(2)
            .height(40)
            .width(40)
            .vCenter()
        
        newMemberEmailField.pin
            .left(16)
            .left(of: addButton)
            .height(20)
            .vCenter()
        
    }
    
    @objc
    func didTapActionButton() {
        guard let email : String = newMemberEmailField.text,
              !email.isEmpty else {
            self.animatePlaceholderColor(self.newMemberEmailField)
            return
        }
        delegate?.didTapAddMemberButton(email: email)
        newMemberEmailField.text = ""
    }
    
}
