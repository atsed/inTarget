//
//  UniqueCell.swift
//  inTarget
//
//  Created by Георгий on 15.04.2021.
//

import Foundation
import UIKit

public class UniqueCell: UICollectionViewCell {
    

        lazy var button: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus.circle")
        button.frame = CGRect(x: 110, y: 40, width: 100, height: 100)
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        button.tintColor = .accent
        return button
    }()
    

    func setupSpecialCell(){
        contentView.addSubview(button)
        
        backgroundColor = .white
        layer.cornerRadius = 30
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 6.0, height: 10.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
    }
    
}
