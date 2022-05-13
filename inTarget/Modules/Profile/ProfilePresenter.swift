//
//  ProfilePresenter.swift
//  inTarget
//
//  Created by Desta on 16.05.2021.
//  
//

import Foundation

final class ProfilePresenter {
    weak var view: ProfileViewInput?
    weak var moduleOutput: ProfileModuleOutput?
    
    private let router: ProfileRouterInput
    private let interactor: ProfileInteractorInput
    
    init(router: ProfileRouterInput,
         interactor: ProfileInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension ProfilePresenter: ProfileModuleInput {
}

extension ProfilePresenter: ProfileViewOutput {
    func getAvatarID(completion: @escaping (Result<String, Error>) -> Void) {
        interactor.getAvatarID() { result in
            switch result {
            case .success(let avatarID):
                completion(.success(avatarID))
                return
            case .failure(_):
                return
            }
            
        }
    }
    
    func didTapLogoutButton() {
        router.showLogOutAlert()
    }
    
    func didLoadView() {
        reloadTotp()
        reloadAvatar()
        reloadName()
        reloadTasksCount()
        reloadGroupsCount()
    }
    
    func reloadAvatar() {
        getAvatarID() { [weak self] result in
            switch result {
            case .success(let avatarID):
                self?.view?.setAvatar(with: avatarID)
            case .failure(_):
                return
            }
        }
    }
    
    func reloadName() {
        interactor.getUserName() { [weak self] result in
            switch result {
            case .success(let userName):
                self?.view?.setUserName(with: userName)
            case .failure(_):
                return
            }
        }
    }

    func reloadTotp() {
        let totp = Totp()
        let value = totp.getTotpCode()

        view?.updateTotp(with: value)
    }
    
    func reloadTasksCount() {
        interactor.getTasksCount() { [weak self] result in
            switch result {
            case .success(let tasksCount):
                self?.view?.setTasksCount(with: tasksCount)
            case .failure(_):
                return
            }
        }
    }

    func reloadGroupsCount() {
        interactor.getGroupsCount() { [weak self] result in
            switch result {
            case .success(let groupsCount):
                self?.view?.setGroupsCount(with: groupsCount)
            case .failure(_):
                return
            }
        }
    }
    
    func didTapAvatarButton() {
        router.showAvatarImagePicker() { [weak self] result in
            switch result {
            case .success(let data):
                if data.isEmpty {
                    self?.interactor.deleteAvatar() { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.reloadAvatar()
                            self?.router.reloadAvatars()
                            return
                        case .failure(_):
                            return
                        }
                    }
                } else {
                    self?.interactor.uploadAvatar(imageData: data) { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.reloadAvatar()
                            self?.router.reloadAvatars()
                            return
                        case .failure(_):
                            return
                        }
                    }
                }
            case .failure(_):
                return
            }
        }
    }
    
    func didTapTasksCardButton() {
        router.openMyTargetsController()
    }
    
    func didTapGroupsCardButton() {
        router.openGroupsController()
    }
}

extension ProfilePresenter: ProfileInteractorOutput {
}
