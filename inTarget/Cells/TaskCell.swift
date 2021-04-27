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
    
    private lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.trackTintColor = .white
        progressBar.progressTintColor = .accent
        progressBar.frame = CGRect(x: 20, y: 150, width: 100, height: 100)
        progressBar.setProgress(0.5, animated: true)
        return progressBar
    }()
    
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var underTasksCount: UILabel = {
        let underTasksCount = UILabel()
        underTasksCount.font = UIFont(name: "GothamPro", size: 15)
        underTasksCount.textColor = .black
        underTasksCount.translatesAutoresizingMaskIntoConstraints = false
        return underTasksCount
    }()

    
    private lazy var yearLabel: UILabel = {
        let date = UILabel()
        date.font = UIFont(name: "GothamPro", size: 11)
        date.textColor = .separator
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamPro", size: 24)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        [imageView, label, yearLabel, underTasksCount, progressBar, openButton].forEach {
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
        setupConstraints()
        
        setupConstraints()
    }
    
    func configure(with task: Task) {
        taskID = task.randomName
        
        let labelUnderTasks : String = underTasksString(value: task.underTasks.count)
        label.text = task.title
        underTasksCount.text = String(task.underTasks.count) + " " + labelUnderTasks
        
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 200),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            yearLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -80),
            yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            underTasksCount.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -50),
            underTasksCount.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            underTasksCount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            underTasksCount.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -120),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
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
