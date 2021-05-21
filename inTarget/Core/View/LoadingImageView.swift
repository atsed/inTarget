//
//  LoadingImageView.swift
//  inTarget
//
//  Created by Desta on 17.05.2021.
//

import UIKit

class LoadingImageView: UIImageView {
    private let imageLoader = ImageLoader()
    private var imageID: String?
    
    func setImage(imageID: String, completion: @escaping (Result<Void, Error>)-> Void) {
        guard !imageID.isEmpty else {
            self.image = UIImage(named: "avatar")
            completion(.success(()))
            return
        }
        
        self.imageID = imageID
        
        imageLoader.downloadImage(imageID) { [weak self] result in
            guard self?.imageID == imageID else {
                return
            }
            
            switch result {
            case .success(let image):
                self?.image = image
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
