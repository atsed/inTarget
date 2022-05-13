//
//  ProfileViewController.swift
//  inTarget
//
//  Created by Desta on 16.05.2021.
//  
//

import UIKit
import PinLayout

final class ProfileViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let headLabel = UILabel()
    private let logoutButton = UIButton()
    private let avatarButton = LoadingButtonImage()
    private let avatarActivityIndicator = UIActivityIndicatorView()
    private let userNameLabel = UILabel()

    private let totpLabel = UILabel()
    
    private let tasksCardContainer = UIView()
    private let tasksCardButton = UIButton(type: .system)
    private let tasksCardCountLabel = UILabel()
    private let tasksCardNameLabel = UILabel()
    private let tasksActivityIndicator = UIActivityIndicatorView()
    
    private let groupsCardContainer = UIView()
    private let groupsCardButton = UIButton(type: .system)
    private let groupsCardCountLabel = UILabel()
    private let groupsCardNameLabel = UILabel()
    private let groupsActivityIndicator = UIActivityIndicatorView()
    
    private let footerLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView()
    
    private let imageLoader = InjectionHelper.imageLoader
    
	private let output: ProfileViewOutput

    init(output: ProfileViewOutput) {
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
		super.viewDidLoad()

        let timer = Timer(fireAt: Date(), interval: 0, target: self, selector: #selector(didReloadTotp), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)

        avatarActivityIndicator.startAnimating()
        tasksActivityIndicator.startAnimating()
        groupsActivityIndicator.startAnimating()
        
        view.backgroundColor = .background
        
        headLabel.text = "Профиль"
        headLabel.textColor = .black
        headLabel.font = UIFont(name: "GothamPro", size: 34)
        
        logoutButton.setImage(UIImage(named: "exit")?.withTintColor(.accent),
                              for: .normal)
        logoutButton.contentVerticalAlignment = .fill
        logoutButton.contentHorizontalAlignment = .fill
        logoutButton.tintColor = .accent
        logoutButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        
        avatarButton.setImage(UIImage(named: "avatar"), for: .normal)
        avatarButton.backgroundColor = .accent
        avatarButton.contentVerticalAlignment = .fill
        avatarButton.contentHorizontalAlignment = .fill
        avatarButton.contentMode = .scaleAspectFit
        avatarButton.tintColor = .accent
        avatarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        avatarButton.layer.cornerRadius = 90
        avatarButton.layer.masksToBounds = true
        avatarButton.addTarget(self, action: #selector(didTapAvatarButton), for: .touchUpInside)
        
        userNameLabel.font = UIFont(name: "GothamPro", size: 26)
        userNameLabel.text = ""
        userNameLabel.textAlignment = .center
        userNameLabel.textColor = .black

        totpLabel.font = UIFont(name: "GothamPro", size: 80)
        totpLabel.textColor = .accent
        totpLabel.textAlignment = .center
        
        tasksCardButton.backgroundColor = .accent
        groupsCardButton.backgroundColor = .lightAccent
        [tasksCardButton, groupsCardButton].forEach {
            ($0).layer.cornerRadius = 30
            ($0).contentVerticalAlignment = .fill
            ($0).contentHorizontalAlignment = .fill
            ($0).contentMode = .scaleAspectFit
            ($0).tintColor = .accent
            ($0).imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            ($0).layer.shadowColor = UIColor.gray.cgColor
            ($0).layer.shadowOffset = CGSize(width: -6.0, height: 10.0)
            ($0).layer.shadowRadius = 6.0
            ($0).layer.shadowOpacity = 1.0
            ($0).layer.masksToBounds = false
        }
        tasksCardButton.addTarget(self, action: #selector(didTapTasksCardButton), for: .touchUpInside)
        groupsCardButton.addTarget(self, action: #selector(didTapGroupsCardButton), for: .touchUpInside)
        
        [tasksCardCountLabel, groupsCardCountLabel].forEach {
            ($0).text = "0"
            ($0).textColor = .white
            ($0).font = UIFont(name: "Noteworthy", size: 50)
        }
        [tasksCardCountLabel, tasksCardNameLabel].forEach {
            ($0).textColor = .lightAccent
        }
        
        [groupsCardCountLabel, groupsCardNameLabel].forEach {
            ($0).textColor = .accent
        }
        
        tasksCardNameLabel.text = "целей"
        groupsCardNameLabel.text = "групп"

        [tasksCardNameLabel, groupsCardNameLabel].forEach {
            ($0).textAlignment = .center
            ($0).font = UIFont(name: "GothamPro", size: 22)
        }
        
        footerLabel.text = "inTarget"
        footerLabel.textColor = .separator.withAlphaComponent(0.3)
        footerLabel.font = UIFont(name: "Noteworthy", size: 20)
        
        [tasksCardButton, tasksCardCountLabel, tasksCardNameLabel, tasksActivityIndicator].forEach { tasksCardContainer.addSubview($0) }
        [groupsCardButton, groupsCardCountLabel, groupsCardNameLabel, groupsActivityIndicator].forEach { groupsCardContainer.addSubview($0) }
        
        [activityIndicator, headLabel, logoutButton, avatarButton, avatarActivityIndicator, userNameLabel, totpLabel, tasksCardContainer, groupsCardContainer, footerLabel].forEach { scrollView.addSubview($0) }

        view.addSubview(scrollView)
        
        output.didLoadView()
	}
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.pin.all()
        
        activityIndicator.pin
            .center()
        
        headLabel.pin
            .top(view.pin.safeArea.top + 30)
            .left(view.pin.safeArea.left + 30)
            .sizeToFit()
        
        logoutButton.pin
            .top(view.pin.safeArea.top + 25)
            .right(view.pin.safeArea.left + 30)
            .size(CGSize(width: 25, height: 25))
        
        avatarButton.pin
            .below(of: headLabel)
            .marginTop(20)
            .hCenter()
            .height(180)
            .width(180)
        
        avatarActivityIndicator.pin
            .below(of: headLabel)
            .marginTop(30)
            .hCenter()
            .height(180)
            .width(180)
        
        userNameLabel.pin
            .below(of: avatarButton)
            .marginTop(20)
            .horizontally()
            .height(24)

        totpLabel.pin
            .below(of: userNameLabel)
            .marginTop(30)
            .horizontally()
            .sizeToFit(.width)
        
        tasksCardContainer.pin
            .below(of: totpLabel)
            .marginTop(30)
            .left(16)
            .width(view.bounds.width/2 - 8 - 16)
            .height(view.bounds.width/2 - 8 - 16)
        
        tasksCardButton.pin
            .all()
        
        tasksCardCountLabel.pin
            .center()
            .sizeToFit()
        
        tasksCardNameLabel.pin
            .bottom()
            .marginBottom(16)
            .height(22)
            .width(of: tasksCardContainer)
            .hCenter()
        
        tasksActivityIndicator.pin
            .all()
        
        groupsCardContainer.pin
            .below(of: totpLabel)
            .marginTop(30)
            .right(16)
            .width(view.bounds.width/2 - 8 - 16)
            .height(view.bounds.width/2 - 8 - 16)
        
        groupsCardButton.pin
            .all()
        
        groupsCardCountLabel.pin
            .center()
            .sizeToFit()
        
        groupsCardNameLabel.pin
            .bottom()
            .marginBottom(16)
            .height(22)
            .width(of: groupsCardContainer)
            .hCenter()
        
        groupsActivityIndicator.pin
            .all()
        
        footerLabel.pin
            .bottom()
            .marginBottom(6)
            .hCenter()
            .sizeToFit()
    }

    func updateTotp(with value: String) {
        totpLabel.text = value
    }
    
    func setAvatar(with avatarID: String) {
        avatarActivityIndicator.startAnimating()
        avatarButton.setImage(imageID: avatarID) { [weak self] _ in
            self?.avatarActivityIndicator.stopAnimating()
        }
    }
    
    func setUserName(with userName: String) {
        activityIndicator.startAnimating()
        userNameLabel.text = userName
        activityIndicator.stopAnimating()
    }
    
    func setTasksCount(with tasksCount: Int) {
        tasksActivityIndicator.startAnimating()
        let label: String = "целей"
        tasksCardCountLabel.text = String(tasksCount)
        tasksCardNameLabel.text = label.changeLabel(count: tasksCount, label: label)
        tasksActivityIndicator.stopAnimating()
    }
    
    func setGroupsCount(with groupsCount: Int) {
        groupsActivityIndicator.startAnimating()
        let label: String = "групп"
        groupsCardCountLabel.text = String(groupsCount)
        groupsCardNameLabel.text = label.changeLabel(count: groupsCount, label: label)
        groupsActivityIndicator.stopAnimating()
    }
    
    @objc
    private func didTapLogoutButton() {
        output.didTapLogoutButton()
    }
    
    @objc
    private func didTapAvatarButton() {
        output.didTapAvatarButton()
    }

    @objc
    private func didReloadTotp() {
        output.reloadTotp()
    }
    
    @objc
    private func didTapTasksCardButton() {
        tasksActivityIndicator.startAnimating()
        output.didTapTasksCardButton()
        tasksActivityIndicator.stopAnimating()
    }
    
    @objc
    private func didTapGroupsCardButton() {
        groupsActivityIndicator.startAnimating()
        output.didTapGroupsCardButton()
        groupsActivityIndicator.stopAnimating()
    }
}

extension ProfileViewController: ProfileViewInput {
}
