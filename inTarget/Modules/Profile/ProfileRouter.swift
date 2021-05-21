//
//  ProfileRouter.swift
//  inTarget
//
//  Created by Desta on 16.05.2021.
//  
//

import UIKit

final class ProfileRouter {
    weak var viewController: UIViewController?
}

extension ProfileRouter: ProfileRouterInput {
    func showLogOutAlert() {
        let dialogMessage = UIAlertController(title: "Предупреждение", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Выйти", style: .default, handler: { [weak self] (action) -> Void in
            
            UserDefaults.standard.setValue(false, forKey: "isAuth")
            let authViewController = AuthViewController()
            authViewController.modalPresentationStyle = .fullScreen
            self?.viewController?.present(authViewController, animated: false, completion: nil)
        })
        
        okAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        dialogMessage.addAction(cancelAction)
        dialogMessage.addAction(okAction)
        
        viewController?.present(dialogMessage, animated: true, completion: nil)
    }
    
    func showAvatarImagePicker(completion: @escaping (Result<Data, Error>) -> Void) {
        let dialogMessage = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let chooseAction = UIAlertAction(title: "Выбрать аватар", style: .default, handler: {
            (action) -> Void in
            let imagePickerController = ImagePickerController()
            self.viewController?.present(imagePickerController, animated: true)
            imagePickerController.showAvatarImagePicker() { result in
                imagePickerController.dismiss(animated: true)
                switch result {
                case .success(let data):
                    imagePickerController.dismiss(animated: true)
                    completion(.success(data))
                case .failure(_):
                    imagePickerController.dismiss(animated: true)
                    return
                }
            }
        })
        
        let deleteAction = UIAlertAction(title: "Удалить аватар", style: .default, handler: { (action) -> Void in
            let emptyData = Data()
            completion(.success(emptyData))
        })
        
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        
        [cancelAction, chooseAction, deleteAction].forEach {
            dialogMessage.addAction($0)
        }
        
        viewController?.present(dialogMessage, animated: true, completion: nil)
    }
    
    func reloadAvatars() {
        (viewController?.tabBarController as? MainTabBarController)?.reloadAvatars()
    }
    
    func openMyTargetsController() {
        viewController?.tabBarController?.selectedIndex = 3
    }
    
    func openGroupsController() {
        viewController?.tabBarController?.selectedIndex = 2
    }
}
