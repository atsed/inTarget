//
//  NewTargetController.swift
//  inTarget
//
//  Created by Георгий on 06.04.2021.
//


import UIKit
import PinLayout

class NewTargetController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private let headLabel = UILabel()
    private let titleField = UITextField()
    private let dateField = UITextField()
    private let descriptionField = UITextField()
    private let addImageButton = UIButton()
    private let addImageView = UIImageView()
    private let deleteImageButton = UIButton()
    private let addImageContainer = UIView()
    private let createButton = UIButton()
    private let scrollView = UIScrollView()
    private let datePicker = UIDatePicker()
    private let newDatePicker = UIDatePicker()
    
    private var kbFrameSize : CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .background
        
        
        headLabel.text = "Новая цель"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
        
        titleField.placeholder = "Наименование цели"
        
        newDatePicker.datePickerMode = .date
        newDatePicker.backgroundColor = .background
        newDatePicker.subviews[0].subviews[0].subviews[0].alpha = 0
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDatePickerButton))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        datePicker.datePickerMode = .date
        dateField.inputAccessoryView = toolBar
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .compact
            datePicker.sizeToFit()
            datePicker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height / 2)
        } else {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }

        dateField.placeholder = "Срок выполнения"
        dateField.inputView = datePicker
        
        descriptionField.placeholder = "Описание"
        descriptionField.contentVerticalAlignment = .top
        [titleField, dateField, descriptionField].forEach {
            ($0).borderStyle = .roundedRect
        }
        
        addImageButton.setTitle("+ Фото цели", for: .normal)
        addImageButton.titleLabel?.font = UIFont(name: "GothamPro", size: 16)
        addImageButton.setTitleColor(.accent, for: .normal)
        addImageButton.backgroundColor = .background
        addImageButton.addTarget(self, action: #selector(didTapAddImageButton), for: .touchUpInside)
        
        addImageContainer.layer.cornerRadius = 20
        addImageContainer.contentMode = .scaleAspectFill
        addImageContainer.clipsToBounds = true
        
        deleteImageButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        deleteImageButton.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        deleteImageButton.tintColor = .accent
        deleteImageButton.alpha = 0
        deleteImageButton.addTarget(self, action: #selector(didTapDeleteImageButton), for: .touchUpInside)
        
        createButton.setTitle("Создать цель", for: .normal)
        createButton.titleLabel?.font = UIFont(name: "GothamPro", size: 16)
        createButton.setTitleColor(.background, for: .normal)
        createButton.backgroundColor = .accent
        createButton.layer.cornerRadius = 14
        createButton.layer.masksToBounds = true
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        
        scrollView.keyboardDismissMode = .onDrag
        
        [addImageView, deleteImageButton].forEach { addImageContainer.addSubview($0)}
        [headLabel, titleField, dateField, descriptionField, addImageButton, addImageContainer, createButton, newDatePicker].forEach { scrollView.addSubview($0) }
        view.addSubview(scrollView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin
            .vertically()
            .horizontally()
        
        headLabel.pin
            .top(view.pin.safeArea.top + 30)
            .left(view.pin.safeArea.left + 30)
            .sizeToFit()
        
        titleField.pin
            .horizontally(16)
            .height(60)
            .below(of: headLabel)
            .marginTop(30)
        
        newDatePicker.pin
            .below(of: titleField)
            .horizontally(16)
            .marginTop(16)
        
        dateField.pin
            .horizontally(16)
            .height(60)
            .below(of: newDatePicker)
            .marginTop(16)
        
        descriptionField.pin
            .horizontally(16)
            .height(138)
            .below(of: dateField)
            .marginTop(16)
        
        addImageButton.pin
            .sizeToFit()
            .below(of: descriptionField)
            .marginTop(16)
            .left(16)
        
        addImageContainer.pin
            .below(of: addImageButton)
            .left(16)
        
        addImageView.pin
            .height(100)
            .width(100)
        
        deleteImageButton.pin
            .left(60)
            .height(40)
            .width(40)
        
        addImageContainer.pin
            .height(100)
            .width(100)
        
        createButton.pin
            .horizontally(16)
            .height(56)
            .bottom(view.pin.safeArea.bottom + 20)
            
    }
    
    @objc
    private func didTapAddImageButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
        
    }
    
    @objc
    private func didTapCreateButton() {
        
    }
    
    @objc private func didTapDatePickerButton() {
        getDateFromPicker()
        view.endEditing(true)
    }
    
    @objc
    private func didTapDeleteImageButton() {
        self.addImageView.image = .none
        self.deleteImageButton.alpha = 0
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        self.addImageView.image = image
        self.addImageView.alpha = 0.5
        self.deleteImageButton.alpha = 1
    }
    
    func getDateFromPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        dateField.text = formatter.string(from: datePicker.date)
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    func checkKeyboardNotifications() {
         NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc
    func kbDidShow(_ notification : Notification) {
        let userInfo = notification.userInfo
        kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height  + kbFrameSize.height)
    }
    
    @objc
    func kbDidHide() {
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height  - kbFrameSize.height)
        scrollView.contentOffset = CGPoint.zero
    }
}
