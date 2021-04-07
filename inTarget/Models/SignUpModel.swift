//
//  SignUpModel.swift
//  inTarget
//
//  Created by Desta on 07.04.2021.
//

import Foundation
import Firebase

class SignUpModel {
    func singUp (_ nameField : UITextField, _ surnameField : UITextField, _ loginField : UITextField, _ passwordField : UITextField, completion: @escaping (Bool?, String?) -> Void) {
        guard let nameText = nameField.text,
              let surnameText = surnameField.text,
              let loginText = loginField.text,
              let passwordText = passwordField.text,
              nameText != "",
              surnameText != "",
              loginText != "",
              passwordText != "" else {
            completion(false, "Заполните все поля")
            return
        }
        Auth.auth().createUser(withEmail: loginText, password: passwordText) { (user, error) in
            if error != nil || user == nil {
                if error!.localizedDescription == "The email address is already in use by another account." {
                    completion(false, "Данный email уже зарегистрирован")
                } else {
                    completion(false, error!.localizedDescription)
                }
                return
            }
            if error == nil && user != nil  {
                completion(true, "True")
                return
            }
        }
        return
    }
}
