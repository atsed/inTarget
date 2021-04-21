//
//  UnderTaskCell.swift
//  inTarget
//
//  Created by Desta on 21.04.2021.
//

import Foundation
import UIKit

class UnderTaskCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamPro", size: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        let date = UILabel()
        date.font = UIFont(name: "GothamPro", size: 14)
        date.textColor = .separator
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        
        backgroundColor = .lightAccent
        layer.cornerRadius = 18
        layer.masksToBounds = false
        
        setupConstraints()
    }
    
    func configure(with underTask: UnderTask) {
        titleLabel.text = underTask.title
        
        let oldDAteFormatter = DateFormatter()
        oldDAteFormatter.dateFormat = "dd MM yyyy"
        guard let oldDate = oldDAteFormatter.date(from: underTask.date) else {
            return
        }
        
        let newDAteFormatter = DateFormatter()
        newDAteFormatter.dateFormat = "dd MMMM yyyy"
        let newDate = newDAteFormatter.string(from: oldDate)
        
        yearLabel.text = newDate

    }
    
    private func setupConstraints() {
        titleLabel.pin
            .top(12)
            .height(16)
            .horizontally(16)
        
        yearLabel.pin
            .below(of: titleLabel)
            .marginTop(8)
            .height(14)
            .horizontally(16)

    }
}
