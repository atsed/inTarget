//
//  DatabaseModel.swift
//  inTarget
//
//  Created by Desta on 12.04.2021.
//

import Foundation
import Firebase

class DatabaseModel {
    let database = Firestore.firestore().collection("users")
    
    func createDatabase(name: String, surname: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let userData = UserDataModel(user: currentUser, name: name, surName: surname)
        let data = ["name" : userData.name,
                    "uid" : userData.uid,
                    "surname" : userData.surName,
                    "email" : userData.email,
                    "avatar" : userData.avatar,
                    "friends" : userData.friends,
                    "groups" : userData.groups,
                    "tasks" : userData.tasks] as [String : Any]
        
        database.document(userData.uid).setData(data)
    }
    
    func createTask(_ titleText : String, _ date : String, _ image : String, comletion: @escaping (Result<String, Error>) -> Void) {
//        guard let title = titleText,
//              let imageN = image,
//              let dateN = date,
//              title != "",
//              imageN != "" else {
//            comletion(.failure())
//            return
//        }
    }
    
}
