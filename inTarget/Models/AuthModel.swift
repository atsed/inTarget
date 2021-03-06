//
//  AuthModel.swift
//  inTarget
//
//  Created by Desta on 06.04.2021.
//

import Foundation
import Firebase

class AuthModel {
    
    func signIn(_ loginField: UITextField, _ passwordField: UITextField, completion: @escaping (Bool?, String?) -> Void) {
        guard let loginText = loginField.text,
              let passwordText = passwordField.text,
              loginText != "", passwordText != "" else {
            
            completion(false, "Пустой логин или пароль")
            return
        }
        
        Auth.auth().signIn(withEmail: loginText, password: passwordText) { (user, error) in
            guard user != nil else {
                completion(false, "Неверный логин или пароль")
                return
            }
            
            completion(true, "True")
        }
        return
    }
}
