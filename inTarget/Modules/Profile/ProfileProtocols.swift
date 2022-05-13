//
//  ProfileProtocols.swift
//  inTarget
//
//  Created by Desta on 16.05.2021.
//  
//

import Foundation

protocol ProfileModuleInput {
	var moduleOutput: ProfileModuleOutput? { get }
}

protocol ProfileModuleOutput: AnyObject {
}

protocol ProfileViewInput: AnyObject {
    func setAvatar(with avatarID: String)
    func setUserName(with userName: String)
    func setTasksCount(with tasksCount: Int)
    func setGroupsCount(with groupsCount: Int)
    func updateTotp(with value: String)
}

protocol ProfileViewOutput: AnyObject {
    func getAvatarID(completion: @escaping (Result<String, Error>) -> Void)
    func didTapLogoutButton()
    func didTapAvatarButton()
    func didLoadView()
    func didTapTasksCardButton()
    func didTapGroupsCardButton()
    func reloadTotp()
}

protocol ProfileInteractorInput: AnyObject {
    func getAvatarID(completion: @escaping (Result<String, Error>) -> Void)
    func uploadAvatar(imageData : Data,
                      completion: @escaping (Result<String, Error>) -> Void)
    func deleteAvatar(completion: @escaping (Result<Void, Error>)-> Void)
    func getUserName(completion: @escaping (Result<String, Error>)-> Void)
    func getTasksCount(completion: @escaping (Result<Int, Error>)-> Void)
    func getGroupsCount(completion: @escaping (Result<Int, Error>)-> Void)
}

protocol ProfileInteractorOutput: AnyObject {
}

protocol ProfileRouterInput: AnyObject {
    func showLogOutAlert()
    func showAvatarImagePicker(completion: @escaping (Result<Data, Error>) -> Void)
    func reloadAvatars()
    func openMyTargetsController()
    func openGroupsController()
}
