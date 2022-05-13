//
//  AuthModel.swift
//  inTarget
//
//  Created by Desta on 06.04.2021.
//

import Foundation
import Firebase

class AuthModel {
    private let secureDatabase = TotpModel()

    func signIn(login: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: login, password: password) { user, error in
            guard
                error == nil,
                let user = user
            else {
                completion(.failure(AuthError.invalidInput))
                return
            }

            let totp = Totp()
            totp.putUidCode(uid: user.user.uid)
            completion(.success(""))
        }
        return
    }

    func checkTotp(with email: String, code: String, completion: @escaping (Result<String, Error>) -> Void) {
        secureDatabase.checkTotp(email: email, code: code) { result in
            switch result {
            case .success:
                completion(.success(""))
            case .failure:
                completion(.failure(AuthError.invalidTotp))
            }
        }
    }
}
