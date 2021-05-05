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
    private let segmentedControl = UISegmentedControl(items: ["Личная цель", "Групповая цель"])
    private let scrollViewSegmCon = UIScrollView()
    
    private let taskTitleField = UITextField()
    private let taskTitleSeparator = UIView()
    private let taskDatePicker = UIDatePicker()
    private let taskAddImageButton = UIButton()
    private let taskAddImageView = UIImageView()
    private let taskDeleteImageButton = UIButton()
    private let taskAddImageContainer = UIView()
    private let createTaskButton = UIButton(type: .system)
    private let taskScrollView = UIScrollView()
    
    private let groupTitleField = UITextField()
    private let groupTitleSeparator = UIView()
    private let groupDatePicker = UIDatePicker()
    private let groupAddImageButton = UIButton()
    private let groupAddImageView = UIImageView()
    private let groupDeleteImageButton = UIButton()
    private let groupAddImageContainer = UIView()
    private let createGroupButton = UIButton(type: .system)
    private let groupScrollView = UIScrollView()
    
    private var image = UIImage()
    
    var valueSegmCon = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .background
        
        headLabel.text = "Новая цель"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
        headLabel.sizeToFit()

        fixBackgroundSegmentControl(segmentedControl)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        segmentedControl.backgroundColor = .lightAccent
        segmentedControl.selectedSegmentTintColor = .accent
        segmentedControl.selectedSegmentIndex = valueSegmCon
        swipeSegmentedControl(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(swipeSegmentedControl(_:)), for: .allEvents)
        
        taskTitleField.placeholder = "Наименование цели"
        taskTitleField.borderStyle = .none
        
        taskTitleSeparator.backgroundColor = .separator
        
        taskDatePicker.datePickerMode = .date
        if #available(iOS 14, *) {
            taskDatePicker.preferredDatePickerStyle = .inline
            taskDatePicker.sizeToFit()

        } else {
            taskDatePicker.sizeToFit()
        }
        taskDatePicker.tintColor = .accent
        taskDatePicker.subviews[0].subviews[0].subviews[0].tintColor = .accent
        
        taskAddImageButton.setTitle("+ Фото цели", for: .normal)
        taskAddImageButton.titleLabel?.font = UIFont(name: "GothamPro", size: 16)
        taskAddImageButton.setTitleColor(.accent, for: .normal)
        taskAddImageButton.backgroundColor = .background
        taskAddImageButton.addTarget(self, action: #selector(didTapAddImageButton), for: .touchUpInside)
        
        taskAddImageContainer.layer.cornerRadius = 20
        taskAddImageContainer.contentMode = .scaleAspectFill
        taskAddImageContainer.clipsToBounds = true
        
        taskDeleteImageButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        taskDeleteImageButton.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        taskDeleteImageButton.tintColor = .accent
        taskDeleteImageButton.alpha = 0
        taskDeleteImageButton.addTarget(self, action: #selector(didTapTaskDeleteImageButton), for: .touchUpInside)
        
        createTaskButton.setTitle("Создать цель", for: .normal)
        createTaskButton.titleLabel?.font = UIFont(name: "GothamPro", size: 16)
        createTaskButton.setTitleColor(.background, for: .normal)
        createTaskButton.backgroundColor = .accent
        createTaskButton.layer.cornerRadius = 14
        createTaskButton.layer.masksToBounds = true
        createTaskButton.addTarget(self, action: #selector(didTapCreateTaskButton), for: .touchUpInside)
        
        groupTitleField.placeholder = "Наименование группы"
        groupTitleField.borderStyle = .none
        
        groupTitleSeparator.backgroundColor = .separator
        
        groupDatePicker.datePickerMode = .date
        if #available(iOS 14, *) {
            groupDatePicker.preferredDatePickerStyle = .inline
            groupDatePicker.sizeToFit()

        } else {
            groupDatePicker.sizeToFit()
        }
        groupDatePicker.tintColor = .accent
        groupDatePicker.subviews[0].subviews[0].subviews[0].tintColor = .accent
        
        groupAddImageButton.setTitle("+ Фото группы", for: .normal)
        groupAddImageButton.titleLabel?.font = UIFont(name: "GothamPro", size: 16)
        groupAddImageButton.setTitleColor(.accent, for: .normal)
        groupAddImageButton.backgroundColor = .background
        groupAddImageButton.addTarget(self, action: #selector(didTapAddImageButton), for: .touchUpInside)
        
        groupAddImageContainer.layer.cornerRadius = 20
        groupAddImageContainer.contentMode = .scaleAspectFill
        groupAddImageContainer.clipsToBounds = true
        
        groupDeleteImageButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        groupDeleteImageButton.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        groupDeleteImageButton.tintColor = .accent
        groupDeleteImageButton.alpha = 0
        groupDeleteImageButton.addTarget(self, action: #selector(didTapGroupDeleteImageButton), for: .touchUpInside)
        
        createGroupButton.setTitle("Создать группу", for: .normal)
        createGroupButton.titleLabel?.font = UIFont(name: "GothamPro", size: 16)
        createGroupButton.setTitleColor(.background, for: .normal)
        createGroupButton.backgroundColor = .accent
        createGroupButton.layer.cornerRadius = 14
        createGroupButton.layer.masksToBounds = true
        createGroupButton.addTarget(self, action: #selector(didTapCreateGroupButton), for: .touchUpInside)
        
        taskScrollView.keyboardDismissMode = .onDrag
        groupScrollView.keyboardDismissMode = .onDrag
        
        [taskAddImageView, taskDeleteImageButton].forEach { taskAddImageContainer.addSubview($0)}
        [groupAddImageView, groupDeleteImageButton].forEach { groupAddImageContainer.addSubview($0)}
        
        [taskTitleField, taskTitleSeparator, taskDatePicker, taskAddImageButton, taskAddImageContainer, createTaskButton].forEach { taskScrollView.addSubview($0) }
        [groupTitleField, groupTitleSeparator, groupDatePicker, groupAddImageButton, groupAddImageContainer, createGroupButton].forEach { groupScrollView.addSubview($0) }
        
        [taskScrollView, groupScrollView].forEach { scrollViewSegmCon.addSubview($0) }
        
        [headLabel, segmentedControl, scrollViewSegmCon].forEach { view.addSubview($0) }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentedControl.selectedSegmentIndex = valueSegmCon
        swipeSegmentedControl(segmentedControl)
        
        headLabel.pin
            .top(view.pin.safeArea.top + 30)
            .left(view.pin.safeArea.left + 30)
            .width(250)
        
        segmentedControl.pin
            .below(of: headLabel)
            .marginTop(25)
            .height(36)
            .horizontally(16)
        
        scrollViewSegmCon.pin
            .below(of: segmentedControl)
            .bottom()
            .horizontally()
        
        taskScrollView.pin
            .top()
            .bottom()
            .horizontally()
        
        taskTitleField.pin
            .top()
            .marginTop(5)
            .horizontally(16)
            .height(60)
        
        taskTitleSeparator.pin
            .below(of: taskTitleField)
            .horizontally(16)
            .height(0.1)
        
        taskDatePicker.pin
            .below(of: taskTitleField)
            .marginTop(16)
            .horizontally(20)
        
        taskAddImageButton.pin
            .sizeToFit()
            .below(of: taskDatePicker)
            .left(16)
        
        taskAddImageContainer.pin
            .below(of: taskAddImageButton)
            .left(16)
        
        taskAddImageView.pin
            .height(100)
            .width(100)
        
        taskDeleteImageButton.pin
            .left(60)
            .height(40)
            .width(40)
        
        taskAddImageContainer.pin
            .height(100)
            .width(100)
        
        createTaskButton.pin
            .below(of: taskAddImageContainer)
            .marginTop(8)
            .horizontally(16)
            .height(56)
        
        
        
        groupScrollView.pin
            .below(of: segmentedControl)
            .right(of: taskScrollView)
            .height(of: taskScrollView)
            .width(of: taskScrollView)
        
        groupTitleField.pin
            .top()
            .marginTop(5)
            .horizontally(16)
            .height(60)
        
        groupTitleSeparator.pin
            .below(of: groupTitleField)
            .horizontally(16)
            .height(0.1)
        
        groupDatePicker.pin
            .below(of: groupTitleField)
            .marginTop(16)
            .horizontally(20)
        
        groupAddImageButton.pin
            .sizeToFit()
            .below(of: groupDatePicker)
            .left(16)
        
        groupAddImageContainer.pin
            .below(of: groupAddImageButton)
            .left(16)
        
        groupAddImageView.pin
            .height(100)
            .width(100)
        
        groupDeleteImageButton.pin
            .left(60)
            .height(40)
            .width(40)
        
        groupAddImageContainer.pin
            .height(100)
            .width(100)
        
        createGroupButton.pin
            .below(of: groupAddImageContainer)
            .marginTop(8)
            .horizontally(16)
            .height(56)
        
        taskScrollView.contentSize = CGSize(width: taskScrollView.bounds.width, height: createTaskButton.frame.maxY + 16)
        groupScrollView.contentSize = CGSize(width: groupScrollView.bounds.width, height: createGroupButton.frame.maxY + 16)
    }
    
    @objc
    private func swipeSegmentedControl(_ sender: UISegmentedControl) {
        print("segmentedControl.selectedSegmentIndex: \(segmentedControl.selectedSegmentIndex)")
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("CASE 0")
            valueSegmCon = 0
            headLabel.text = "Новая цель"
            scrollViewSegmCon.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case 1:
            print("CASE 1")
            valueSegmCon = 1
            headLabel.text = "Новая группа"
            scrollViewSegmCon.setContentOffset(CGPoint(x: view.bounds.width, y: 0), animated: true)
        default:
            print("ERROR swipeSegmentedControl")
        }
    }
    
    @objc
    private func didTapAddImageButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc
    private func didTapCreateTaskButton() {
        guard let title = self.taskTitleField.text,
              !title.isEmpty else {
            
            self.animatePlaceholderColor(self.taskTitleField, self.taskTitleSeparator)
            return
        }
        
        let database = DatabaseModel()
        let date = getDateFromPicker()
        let imageLoader = InjectionHelper.imageLoader
        var imageName = ""
        
        imageLoader.uploadImage(image) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let imageRandomName):
                imageName = imageRandomName
                database.createTask(title, date, imageName) { [weak self] result in
                    switch result {
                    case .success(let taskName):
                        (self?.tabBarController as? MainTabBarController)?.reloadVC1()
                        (self?.tabBarController as? MainTabBarController)?.reloadVC4()
                        (self?.tabBarController as? MainTabBarController)?.openGoalVC4(with: taskName)
                        self?.taskTitleField.text = ""
                        self?.didTapTaskDeleteImageButton()
                    case .failure(let error):
                        print("\(error)")
                        
                    }
                }
            case .failure(_):
                self.animateButtonTitleColor(self.taskAddImageButton)
                return
            }
        }
    }
    
    @objc
    private func didTapCreateGroupButton() {
        guard let title = self.groupTitleField.text,
              !title.isEmpty else {
            
            self.animatePlaceholderColor(self.groupTitleField, self.groupTitleSeparator)
            return
        }
        
        let groupDatabase = GroupDatabaseModel()
        let date = getDateFromPicker()
        let imageLoader = InjectionHelper.imageLoader
        var imageName = ""
        
        imageLoader.uploadGroupImage(image) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let imageRandomName):
                imageName = imageRandomName
                groupDatabase.createGroup(title, date, imageName) { [weak self] result in
                    switch result {
                    case .success(let groupName):
                        print("GROUPNAME: \(groupName)")
                        (self?.tabBarController as? MainTabBarController)?.reloadVC1()
                        (self?.tabBarController as? MainTabBarController)?.reloadVC3()
                        (self?.tabBarController as? MainTabBarController)?.openGoalVC3(with: groupName)
                        self?.groupTitleField.text = ""
                        self?.didTapGroupDeleteImageButton()
                    case .failure(let error):
                        print("\(error)")
                        
                    }
                }
            case .failure(_):
                self.animateButtonTitleColor(self.groupAddImageButton)
                return
            }
        }
    }
    
    @objc
    private func didTapTaskDeleteImageButton() {
        taskAddImageView.image = .none
        taskDeleteImageButton.alpha = 0
    }
    
    @objc
    private func didTapGroupDeleteImageButton() {
        groupAddImageView.image = .none
        groupDeleteImageButton.alpha = 0
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let addImage = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        image = addImage
        if segmentedControl.selectedSegmentIndex == 0 {
            taskAddImageView.image = image
            taskAddImageView.alpha = 0.5
            taskDeleteImageButton.alpha = 1
        } else if segmentedControl.selectedSegmentIndex == 1 {
            groupAddImageView.image = image
            groupAddImageView.alpha = 0.5
            groupDeleteImageButton.alpha = 1
        }
    }
    
    func getDateFromPicker() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        let dateString = formatter.string(from: taskDatePicker.date)
        return (dateString)
    }

}

extension UIViewController {
    func fixBackgroundSegmentControl( _ segmentControl: UISegmentedControl){
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(segmentControl.numberOfSegments-1)  {
                    let backgroundSegmentView = segmentControl.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    backgroundSegmentView.isHidden = true
                }
            }
        }
    }
}
