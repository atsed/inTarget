//
//  TotpModel.swift
//  inTarget
//
//  Created by Короткий Егор on 25.04.2022.
//

import Foundation

struct ResultModel: Codable {
    let value: Bool
}

struct UserModel: Codable {
    let id: String?
    let email: String
    let secret: String
}

final class TotpModel {
    func createDatabase(email: String, uid: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let user = UserModel(id: nil, email: "\(email)", secret: "\(uid)")

        guard
            let url = URL(string: "http://192.168.1.130:8080/addUser"),
            let jsonData = try? JSONEncoder().encode(user)
        else {
            completion(.failure(NSError()))
            return
        }

        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, responce, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError()))
                return
            }

            let decoder = JSONDecoder()

            do {
                let value = try decoder.decode(UserModel.self, from: data)
                let totp = Totp()
                totp.putUidCode(uid: uid)
                completion(.success(value))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func checkTotp(email: String, code: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let jsonData = ["email" : "\(email)", "code" : "\(code)"]

        guard
            let url = URL(string: "http://192.168.1.130:8080/checkTotp"),
            let httpBody = try? JSONSerialization.data(withJSONObject: jsonData, options: [])
        else {
            completion(.failure(NSError()))
            return
        }

        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, responce, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError()))
                return
            }

            let decoder = JSONDecoder()

            do {
                let result = try decoder.decode(ResultModel.self, from: data)
                if result.value {
                    completion(.success(result.value))
                } else {
                    completion(.failure(NSError()))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
