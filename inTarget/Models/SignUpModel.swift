//
//  SignUpModel.swift
//  inTarget
//
//  Created by Desta on 07.04.2021.
//

import Foundation
import Firebase

class SignUpModel {
    private let database = DatabaseModel()
    private let secureDatabase = TotpModel()
    
    func singUp(with nameField : UITextField,
                surnameField : UITextField,
                loginField : UITextField,
                passwordField : UITextField,
                completion: @escaping (Bool?, String?) -> Void) {
        guard
            let nameText = nameField.text,
            let surnameText = surnameField.text,
            let loginText = loginField.text,
            let passwordText = passwordField.text,
            !nameText.isEmpty,
            !surnameText.isEmpty,
            loginText != "",
            passwordText != ""
        else {
            
            completion(false, "Заполните все поля")
            return
        }
        Auth.auth().createUser(withEmail: loginText, password: passwordText) { [weak self] (user, error) in
            guard
                error == nil,
                let user = user
            else {
                completion(false, error!.localizedDescription)
                return
            }

            self?.database.createDatabase(name: nameText, surname: surnameText) { result in
                switch result {
                case .success:
                    self?.secureDatabase.createDatabase(email: loginText, uid: user.user.uid) { result in
                        switch result {
                        case .success:
                            completion(true, "True")
                        case .failure:
                            completion(false, "Error: \(NSError())")
                        }
                    }
                case .failure(let error):
                    completion(false, "Error: \(error)")
                }
            }
        }
    }

    func fastTotp(completion: @escaping (Result<String, Error>) -> Void) {
        guard
            let currentUser = Auth.auth().currentUser,
            let email = currentUser.email
        else {
            completion(.failure(NSError()))
            return
        }
        secureDatabase.createDatabase(email: email, uid: currentUser.uid) { result in
            switch result {
            case .success:
                completion(.success(""))
            case .failure:
                completion(.failure(NSError()))
            }
        }
    }
}
