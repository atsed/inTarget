//
//  TaskCell.swift
//  inTarget
//
//  Created by Георгий on 15.04.2021.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
    func didTapOpenTaskButton(taskID : String)
}

class TaskCell: UICollectionViewCell {
    private var taskID : String = ""
    
    weak var delegate: TaskCellDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamPro", size: 24)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamPro", size: 11)
        label.textColor = .separator
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var underTasksLabel: UILabel = {
        let underTasksCount = UILabel()
        underTasksCount.font = UIFont(name: "GothamPro", size: 15)
        underTasksCount.textColor = .black
        underTasksCount.translatesAutoresizingMaskIntoConstraints = false
        return underTasksCount
    }()
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamPro", size: 11)
        label.textColor = .separator
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    
    private lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.trackTintColor = .lightAccent
        progressBar.progressTintColor = .accent
        progressBar.frame = CGRect(x: 20, y: 150, width: 100, height: 100)
        return progressBar
    }()
    
    lazy var openButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .accent
        return button
    }()

    
    private func setup() {
        [imageView, titleLabel, yearLabel, underTasksLabel, titleLabel, progressLabel, progressBar, openButton].forEach {
            contentView.addSubview($0)
        }
        
        backgroundColor = .white
        layer.cornerRadius = 30
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 6.0, height: 10.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        
        openButton.addTarget(self, action: #selector(didTapOpenButton), for: .touchUpInside)
    }
    
    func configure(with task: Task) {
        taskID = task.randomName
        
        let labelUnderTasks : String = underTasksString(value: task.underTasks.count)
        titleLabel.text = task.title
        underTasksLabel.text = String(task.underTasks.count) + " " + labelUnderTasks
        
        let oldDAteFormatter = DateFormatter()
        oldDAteFormatter.dateFormat = "dd MM yyyy"
        guard let oldDate = oldDAteFormatter.date(from: task.date) else {
            return
        }
        
        let newDAteFormatter = DateFormatter()
        newDAteFormatter.dateFormat = "dd MMMM yyyy"
        let newDate = newDAteFormatter.string(from: oldDate)
        
        yearLabel.text = newDate
        
        InjectionHelper.imageLoader.downloadImage(task.image) { [weak self] result in
            switch result {
            case .success(let image):
                self?.imageView.image = image
            case .failure:
                return
            }
        }
                
        var completedTasks = 0
        let underTasks = task.underTasks
        for underTask in underTasks {
            if underTask.isCompleted == true {
                completedTasks += 1
            }
        }
        
        
        if underTasks.count == 0 {
            progressLabel.text = "0" + "%"
            progressBar.setProgress(.zero, animated: true)
        } else {
            let progress : Float = Float(completedTasks)/Float(underTasks.count)
            progressLabel.text = String(Int(progress * 100)) + "%"
            progressBar.setProgress(progress, animated: true)
        }
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.pin
            .bottom()
            .right()
            .height(150)
            .width(150)
        
        titleLabel.pin
            .left(of: imageView)
            .top(20)
            .left(20)
            .height(24)
            .width(200)
        
        yearLabel.pin
            .below(of: titleLabel)
            .left(of: imageView)
            .marginTop(5)
            .left(20)
            .height(11)
            .width(200)
        
        underTasksLabel.pin
            .below(of: yearLabel)
            .left(of: imageView)
            .marginTop(2)
            .left(20)
            .height(15)
            .width(200)
        
        progressBar.pin
            .bottom(20)
            .left(20)
            .height(20)
            .width(120)
        
        progressLabel.pin
            .above(of: progressBar)
            .height(11)
            .left(20)
            .width(of: progressBar)
        
        openButton.pin
            .horizontally()
            .vertically()
    }
    
    @objc
    func didTapOpenButton() {
        guard !taskID.isEmpty else {
            return
        }
        delegate?.didTapOpenTaskButton(taskID: taskID)
    }
}

extension TaskCell {
    func underTasksString(value: Int) -> String {

        var underTasksLabel: String = ""
        
        if value == 1 {
            underTasksLabel = "подзадача"
        }
        if value % 10 == 2 ||
                    value % 10 == 3 ||
                    value % 10 == 4 {
            underTasksLabel = "подзадачи"
        }
        if value % 10 == 5 ||
                    value % 10 == 6 ||
                    value % 10 == 7 ||
                    value % 10 == 8 ||
                    value % 10 == 9 ||
                    value % 10 == 0 {
            underTasksLabel = "подзадач"
        }
        if value % 100 == 11 ||
                    value % 100 == 12 ||
                    value % 100 == 13 ||
                    value % 100 == 14 {
            underTasksLabel = "подзадач"
        }
        
        return underTasksLabel
    }
}
