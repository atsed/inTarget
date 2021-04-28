//
//  NewTaskCell.swift
//  inTarget
//
//  Created by Георгий on 15.04.2021.
//
import UIKit

protocol NewTaskCellDelegate: AnyObject {
    func didTapActionButton()
}

public class NewTaskCell: UICollectionViewCell {
    
    weak var delegate: NewTaskCellDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "add")?.withTintColor(.accent)
        button.setImage(image, for: .normal)
        button.tintColor = .accent
        return button
    }()
    

    private func setup() {
        contentView.addSubview(button)

        backgroundColor = .white
        layer.cornerRadius = 30
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 6.0, height: 10.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        setupConstraints()
    }
    
    @objc
    func didTapAddButton() {
        delegate?.didTapActionButton()
    }
    
    private func setupConstraints() {
        
        button.pin
            .vertically()
            .horizontally()
            
    }
}
