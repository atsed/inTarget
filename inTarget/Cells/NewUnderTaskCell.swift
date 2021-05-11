//
//  NewUnderTaskCell.swift
//  inTarget
//
//  Created by Desta on 21.04.2021.
//

import UIKit

protocol NewUnderTaskCellDelegate: AnyObject {
    func didTapAddUnderTaskButton(title : String, date : String)
}

public class NewUnderTaskCell: UICollectionViewCell {
    private var taskName : String = ""
    
    weak var delegate: NewUnderTaskCellDelegate?
    
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
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .compact

            let image = UIImage(systemName: "calendar.circle")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
            
            datePicker.addSubview(imageView)
            datePicker.sizeToFit()
        } else {
            datePicker.sizeToFit()
        }
        
        datePicker.tintColor = .accent
        datePicker.subviews[0].subviews[0].subviews[0].tintColor = .accent
        
        return datePicker
    }()
    
    private lazy var datePickerButton : UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "calendar.circle")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .accent
        return button
    }()
    
    private lazy var titleUnderTaskField : UITextField =  {
        let textField = UITextField()
        textField.placeholder = "Наименование подзадачи"
        textField.borderStyle = .none
        return textField
    }()
    

    private func setup() {
        [addButton, titleUnderTaskField, datePicker].forEach {
            contentView.addSubview($0)
        }
        
        backgroundColor = .lightAccent
        layer.cornerRadius = 18
        layer.masksToBounds = false
        
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        datePickerButton.addTarget(self, action: #selector(didTapDatePickerButton), for: .touchUpInside)
    }
 
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        addButton.pin
            .left(10)
            .height(45)
            .width(45)
            .vCenter()
        
        datePicker.pin
            .right(10)
            .width(45)
            .height(45)
            .vCenter()
        
        titleUnderTaskField.pin
            .right(of: addButton)
            .marginLeft(10)
            .left(of: datePicker)
            .sizeToFit()
            .vCenter()

    }
    
    @objc
    func didTapAddButton() {
        guard let title : String = titleUnderTaskField.text,
              !title.isEmpty else {
            self.animatePlaceholderColor(self.titleUnderTaskField)
            return
        }
        
        let date = getDateFromPicker()

        delegate?.didTapAddUnderTaskButton(title: title, date: date)
        titleUnderTaskField.text = ""
    }
    
    @objc
    func didTapDatePickerButton() {

    }
    
    func getDateFromPicker() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        let dateString = formatter.string(from: datePicker.date)
        return (dateString)
    }
}

extension UICollectionViewCell {
    func animatePlaceholderColor(_ titleField : UITextField) {
        let redColor = UIColor.red.withAlphaComponent(0.5)
        let grayColor = UIColor.gray.withAlphaComponent(0.5)
        titleField.attributedPlaceholder = NSAttributedString(string: titleField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : redColor])
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
            titleField.attributedPlaceholder = NSAttributedString(string: titleField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : grayColor])
        }
    }
}
