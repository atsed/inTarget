//
//  MyTargetController.swift
//  inTarget
//
//  Created by Desta on 19.04.2021.
//

import UIKit
import PinLayout

class MyTargetController: UIViewController {
    private let imageView = UIImageView()
    private let gradientView = UIView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let imageViewContainer = UIView()
    private let underTaskLabel = UILabel()
    private let scrollView = UIScrollView()
    private let database = DatabaseModel()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(UnderTaskCell.self, forCellWithReuseIdentifier: "UnderTaskCell")
        cv.register(NewUnderTaskCell.self, forCellWithReuseIdentifier: "NewUnderTaskCell")
        return cv
    }()
    
    private var kbFrameSize : CGRect = .zero
    private var task : Task = Task(randomName: "", title: "", date: "", image: "")
    var taskName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        loadTask()
        
        view.backgroundColor = .background
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0.9

        titleLabel.font = UIFont(name: "GothamPro-Light", size: 29)
        dateLabel.font = UIFont(name: "GothamPro-Light", size: 14)
        underTaskLabel.font = UIFont(name: "GothamPro", size: 18)
        underTaskLabel.text = "Подзадачи"
        underTaskLabel.textAlignment = .left
        underTaskLabel.textColor = .black
        
        [titleLabel, dateLabel].forEach() {
            ($0).textColor = .background
            ($0).textAlignment = .left
        }
        
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 30
        collectionView.layer.masksToBounds = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        [imageView, gradientView, titleLabel, dateLabel].forEach { imageViewContainer.addSubview($0) }
        [imageViewContainer, underTaskLabel, collectionView].forEach { scrollView.addSubview($0) }
        view.addSubview(scrollView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        scrollView.pin
            .horizontally()
            .vertically()
        
        imageViewContainer.pin
            .top(-view.pin.safeArea.top - (navigationController?.navigationBar.bounds.height ?? 0) )
            .horizontally()
        
        imageView.pin
            .top()
            .width(view.bounds.width)
            .height(view.bounds.width)
        
        gradientView.pin
            .top()
            .width(view.bounds.width)
            .height(view.bounds.width)
        
        addGradient()
        
        titleLabel.pin
            .top(view.bounds.width - 70)
            .height(30)
            .horizontally(16)
        
        dateLabel.pin
            .below(of: titleLabel)
            .marginTop(2)
            .height(30)
            .horizontally(16)
        
        imageViewContainer.pin
            .width(view.bounds.width)
            .height(view.bounds.width)
        
        underTaskLabel.pin
            .below(of: imageViewContainer)
            .marginTop(20)
            .sizeToFit()
            .horizontally(16)
        
        collectionView.pin
            .below(of: underTaskLabel)
            .marginTop(20)
            .horizontally(16)
            .height(300)
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .background
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()

        let backButtonImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        navigationController?.navigationBar.backItem?.backButtonTitle = ""
    }
    
    private func loadTask() {
        database.getTask(taskName: taskName) { [weak self] result in
            switch result {
            case .success(let task):
                self?.task = task
                
                self?.titleLabel.text = task.title
                
                let newDate = self?.swapDate(date: task.date)
                self?.dateLabel.text = newDate
                
                self?.loadImage()
                //УБРАТЬ
                let testUnderTask = UnderTask(title: "Сделать презентацию",
                                              date: "21 04 1990", isCompleted: false)
                
                self?.task.underTasks.append(testUnderTask)
                self?.task.underTasks.append(testUnderTask)
                self?.task.underTasks.append(testUnderTask)
                self?.task.underTasks.append(testUnderTask)
                self?.task.underTasks.append(testUnderTask)
                //
                self?.collectionView.reloadData()
                print("TAAAAAAASK: \(String(describing: self?.task))")
            case .failure:
                return
            }
        }
    }
    
    private func loadImage() {
        InjectionHelper.imageLoader.downloadImage(task.image) { [weak self] result in
            switch result {
            case .success(let loadImage):
                self?.imageView.image = loadImage
            case .failure:
                return
            }
        }
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gradientView.frame
        gradientLayer.colors = [UIColor.accent.withAlphaComponent(0.75).cgColor,
                                UIColor.accent.withAlphaComponent(0.5).cgColor,
                                UIColor.white.withAlphaComponent(0.25).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    @objc
    private func didTapAddButton(){
        
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
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height  + kbFrameSize.height)
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height / 2)
    }
    
    @objc
    func kbDidHide() {
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height  - kbFrameSize.height)
    }
}

extension MyTargetController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        print("task.underTasks.count + 1: \(task.underTasks.count + 1)")
        return task.underTasks.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == task.underTasks.count {
            guard let newUnderTaskCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewUnderTaskCell", for: indexPath) as? NewUnderTaskCell else {
                return UICollectionViewCell()
            }
            
            newUnderTaskCell.delegate = self
            return newUnderTaskCell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnderTaskCell", for: indexPath) as? UnderTaskCell else {
            return UICollectionViewCell()
        }

        let underTask = task.underTasks[indexPath.row]
        cell.configure(with: underTask)
        
        return cell
    }

}

extension MyTargetController: NewUnderTaskCellDelegate {
    func didTapActionButton() {
        didTapAddButton()
    }
}
