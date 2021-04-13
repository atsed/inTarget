//
//  DatabaseModel.swift
//  inTarget
//
//  Created by Desta on 12.04.2021.
//

import Foundation
import Firebase
import FirebaseFirestore

class DatabaseModel {
    let database = Firestore.firestore().collection("users")
    
    func createDatabase(name: String, surname: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let userData = UserDataModel(user: currentUser, name: name, surName: surname)

        //print("userData: \(userData)")
        database.document(userData.email).setData(["name" : userData.name,
                                                   "uid" : userData.uid,
                                                   "surname" : userData.surName,
                                                   "email" : userData.email,
                                                   "avatar" : userData.avatar,
                                                   "friends" : userData.friends,
                                                   "groups" : userData.groups,
                                                   "tasks" : userData.tasks])

        
    }
    
    func createTask(_ title : String, _ data : String) {
        
    }
    
}
