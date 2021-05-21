//
//  ImagePickerController.swift
//  inTarget
//
//  Created by Desta on 17.05.2021.
//

import UIKit

final class ImagePickerController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private let imageLoader = ImageLoader()
    private let database = DatabaseModel()
    private var completion: ((Result<Data, Error>) -> Void)?
    
    func showAvatarImagePicker(completion: @escaping (Result<Data, Error>) -> Void) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.completion = completion
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            self.dismiss(animated: true)
            self.completion?(.failure(ImageLoader.ImageLoaderError.invalidInput))
            return
        }
        
        let data = image.jpegData(compressionQuality: 1)
        guard let data = data else {
            self.dismiss(animated: true)
            self.completion?(.failure(ImageLoader.ImageLoaderError.invalidInput))
            return
        }
        self.completion?(.success(data))
    }
}
