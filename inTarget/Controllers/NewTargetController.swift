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
    private let imageView = UIImageView()
    private let deleteImageButton = UIButton()
    private let addImageContainer = UIView()
    private let createButton = UIButton()
    private let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        headLabel.text = "Новая цель"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
        
        titleField.placeholder = "Наименование цели"
        dateField.placeholder = "Срок выполнения"
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
        
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0.5
        
        addImageContainer.addSubview(imageView)
        addImageContainer.addSubview(deleteImageButton)
        
        deleteImageButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        //deleteImageButton.imageEdgeInsets = UIEdgeInsets(100, 100, 100, 100)
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
        
        
        
        [headLabel, titleField, dateField, descriptionField, addImageButton, addImageContainer, createButton].forEach { scrollView.addSubview($0) }
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
        
        dateField.pin
            .horizontally(16)
            .height(60)
            .below(of: titleField)
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
            .height(100)
            .width(100)
        
        imageView.pin
            .height(100)
            .width(100)
        
        deleteImageButton.pin
            .above(of: imageView)
            .marginBottom(-100)
            .height(100)
            .width(100)
        
        addImageContainer.pin
            .height(100)
            .width(100)
            .sizeToFit()
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        self.imageView.image = image
        self.deleteImageButton.alpha = 1
    }
    
    @objc
    private func didTapDeleteImageButton() {
        self.imageView.image = .none
        self.deleteImageButton.alpha = 0
    }
}
