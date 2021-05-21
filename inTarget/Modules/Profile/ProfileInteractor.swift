//
//  ProfileInteractor.swift
//  inTarget
//
//  Created by Desta on 16.05.2021.
//  
//

import Foundation

final class ProfileInteractor {
	weak var output: ProfileInteractorOutput?
    
    let imageLoader = InjectionHelper.imageLoader
    let database = DatabaseModel()
    let groupDatabase = GroupDatabaseModel()
}

extension ProfileInteractor: ProfileInteractorInput {
    func getAvatarID(completion: @escaping (Result<String, Error>) -> Void) {
        database.getAvatar() { result in
            switch result {
            case .success(let avatarID):
                if !avatarID.isEmpty {
                    completion(.success(avatarID))
                } else {
                    completion(.success(avatarID))
                }
            case .failure:
                completion(.failure(ImageLoader.ImageLoaderError.invalidInput))
                return
            }
        }

    }
    
    func uploadAvatar(imageData: Data,
                      completion: @escaping (Result<String, Error>) -> Void) {
        
        imageLoader.uploadImage(imageData) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let avatarID):
                self.database.setAvatar(avatarID: avatarID) { result in
                    switch result {
                    case .success(_):
                        completion(.success(avatarID))
                        return
                    case .failure(_):
                        completion(.failure(ImageLoader.ImageLoaderError.invalidInput))
                        return
                    }
                }
            case .failure(_):
                completion(.failure(ImageLoader.ImageLoaderError.invalidInput))
                return
            }
        }
    }
    
    func deleteAvatar(completion: @escaping (Result<Void, Error>)-> Void) {
        database.setAvatar(avatarID: "") { result in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(_):
                completion(.failure(ImageLoader.ImageLoaderError.invalidInput))
            }
        }
    }
    
    func getUserName(completion: @escaping (Result<String, Error>)-> Void) {
        database.getUserName() { result in
            switch result {
            case .success(let name):
                completion(.success(name))
            case .failure(_):
                completion(.failure(ImageLoader.ImageLoaderError.invalidInput))
            }
        }
    }
    
    func getTasksCount(completion: @escaping (Result<Int, Error>)-> Void) {
        database.getTasks() { result in
            switch result {
            case .success(let tasks):
                completion(.success(tasks.count))
            case .failure(_):
                completion(.failure(ImageLoader.ImageLoaderError.invalidInput))
            }
        }
    }
    
    func getGroupsCount(completion: @escaping (Result<Int, Error>)-> Void) {
        groupDatabase.getGroups() { result in
            switch result {
            case .success(let groups):
                completion(.success(groups.count))
            case .failure(_):
                completion(.failure(ImageLoader.ImageLoaderError.invalidInput))
            }
            
        }
    }
}
