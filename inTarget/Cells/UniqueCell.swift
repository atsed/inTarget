//
//  UniqueCell.swift
//  inTarget
//
//  Created by Георгий on 15.04.2021.
//
import UIKit

protocol UniqueCellDelegate: AnyObject {
    func didTapActionButton()
}

public class UniqueCell: UICollectionViewCell {
    
    weak var delegate: UniqueCellDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus.circle")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
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
            .hCenter()
            .vCenter()
            .height(120)
            .width(120)
            
    }
}
