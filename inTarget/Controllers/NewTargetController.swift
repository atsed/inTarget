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
    private let titleSeparator = UIView()
    private let datePicker = UIDatePicker()
    private let addImageButton = UIButton()
    private let addImageView = UIImageView()
    private let deleteImageButton = UIButton()
    private let addImageContainer = UIView()
    private let createButton = UIButton(type: .system)
    private let scrollView = UIScrollView()
    private var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .background
        
        
        headLabel.text = "Новая цель"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
        
        titleField.placeholder = "Наименование цели"
        titleField.borderStyle = .none
        
        titleSeparator.backgroundColor = .separator
        
        datePicker.datePickerMode = .date
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .inline
            datePicker.sizeToFit()

        } else {
            datePicker.sizeToFit()
        }
        datePicker.tintColor = .accent
        datePicker.subviews[0].subviews[0].subviews[0].tintColor = .accent
        
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
        [headLabel, titleField, titleSeparator, datePicker, addImageButton, addImageContainer, createButton].forEach { scrollView.addSubview($0) }
        view.addSubview(scrollView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin
            .top(view.pin.safeArea.top)
            .bottom()
            .horizontally()
        
        headLabel.pin
            .top(30)
            .left(view.pin.safeArea.left + 30)
            .sizeToFit()
        
        titleField.pin
            .horizontally(16)
            .height(60)
            .below(of: headLabel)
            .marginTop(20)
        
        titleSeparator.pin
            .below(of: titleField)
            .horizontally(16)
            .height(0.1)
        
        datePicker.pin
            .below(of: titleField)
            .horizontally(20)
            .marginTop(16)
        
        addImageButton.pin
            .sizeToFit()
            .below(of: datePicker)
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
            .below(of: addImageContainer)
            .marginTop(8)
        
        didPerformLayout()
            
    }
    
    private func didPerformLayout() {
        let tabbar = tabBarController?.tabBar.bounds.height ?? 0

        if self.view.bounds.height - tabbar < createButton.frame.maxY {
            scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: createButton.frame.maxY + 16)
            return
        } else { return }
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
        guard let title = self.titleField.text, title != "" else {
            self.animatePlaceholderColor(self.titleField, self.titleSeparator)
            return }
        
        let database = DatabaseModel()
        let date = getDateFromPicker()
        let imageLoader = ImageLoader()
        var imageName = ""
        var tasksCount = 0
        
        imageLoader.uploadImage(self.image) { (result) in
            switch result {
            case .success(let randomName):
                imageName = randomName
                database.getTasksCount() { (result) in
                    switch result {
                    case .success(let count):
                        tasksCount = count
                        database.createTask(tasksCount, title, date, imageName) { (result) in
                            switch result {
                            case .success(_):
                                print("ЗДЕСЬ НУЖНО ОТКРЫТЬ ЭКРАН ЦЕЛИ")
                                self.titleField.text = ""
                                self.didTapDeleteImageButton()
                            case .failure(let error):
                                print("\(error)")
                            
                            }
                        }
                    case .failure(_):
                        return
                    }
                }
            case .failure(_):
                self.animateButtonTitleColor(self.addImageButton)
                return
            }
        }
    }
    
    @objc
    private func didTapDeleteImageButton() {
        self.addImageView.image = .none
        self.deleteImageButton.alpha = 0
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let addImage = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        self.image = addImage
        self.addImageView.image = image
        self.addImageView.alpha = 0.5
        self.deleteImageButton.alpha = 1
    }
    
    func getDateFromPicker() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        let dateString = formatter.string(from: datePicker.date)
        return(dateString)
    }

}
