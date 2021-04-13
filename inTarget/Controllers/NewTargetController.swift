//
//  NewTargetController.swift
//  inTarget
//
//  Created by Георгий on 06.04.2021.
//


import UIKit
import PinLayout

class NewTargetController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private let addImageButton = UIButton()
    private let imageView = UIImageView()
    private let deleteImageButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
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
        
        deleteImageButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        //deleteImageButton.imageEdgeInsets = UIEdgeInsets(100, 100, 100, 100)
        deleteImageButton.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        deleteImageButton.tintColor = .accent
        deleteImageButton.alpha = 0
        deleteImageButton.addTarget(self, action: #selector(didTapDeleteImageButton), for: .touchUpInside)
        
        
        [addImageButton, imageView,deleteImageButton].forEach { view.addSubview($0) }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addImageButton.pin
            .sizeToFit()
            .center()
        
        imageView.pin
            .below(of: addImageButton)
            .height(100)
            .width(100)
        
        deleteImageButton.pin
            .above(of: imageView)
            .marginBottom(-100)
            .height(100)
            .width(100)
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
