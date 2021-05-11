//
//  UserDataModel.swift
//  inTarget
//
//  Created by Desta on 12.04.2021.
//

import Foundation
import Firebase

struct User {
    var uid : String
    var email : String
    var avatar: String = ""
    var groups : [String] = []
    var name : String
    var surName : String
    
    init(uid : String, email : String, name : String, surName : String) {
        self.uid = uid
        self.email = email
        self.name = name
        self.surName = surName
    }
}
