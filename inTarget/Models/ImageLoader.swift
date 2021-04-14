//
//  ImageLoader.swift
//  inTarget
//
//  Created by Desta on 14.04.2021.
//

import Foundation
import Firebase
import FirebaseStorage

class ImageLoader {
    private let storage = Storage.storage()
    
    func uploadImage(_ image : UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser, let data = image.jpegData(compressionQuality: 1) else {
            print("ImageLoader: CHECK HERE")
            return
        }
        
        let metadata = StorageMetadata()
        let randomName = UUID().uuidString
        storage.reference(withPath: "\(currentUser.uid)").child(randomName).putData(data, metadata: metadata) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(randomName))
            }
        }
    }
    
    func downloadImage(_ imageName : String, completion: @escaping (Result<String, Error>) -> Void) {
        
    }
}
