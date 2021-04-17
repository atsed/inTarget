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
              !nameText.isEmpty,
              !surnameText.isEmpty,
              loginText != "",
              passwordText != "" else {
            
            completion(false, "Заполните все поля")
            return
        }
        Auth.auth().createUser(withEmail: loginText, password: passwordText) { (user, error) in
            if error != nil || user == nil {
                print("BAD DAB DAB")
                completion(false, error!.localizedDescription)
                return
            }
            
            if error == nil && user != nil  {
                let database = DatabaseModel()
                database.createDatabase(name: nameText, surname: surnameText) { (result) in
                    switch result {
                    case .success:
                        print("GOOD DAB DAB222")
                        completion(true, "True")
                        return
                    case .failure(let error):
                        print("BAD DAB DAB222")
                        completion(false, "Error: \(error)")
                        return
                    }
                }
            }
        }
        return
    }
}
