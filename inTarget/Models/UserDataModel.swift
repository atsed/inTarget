//
//  UserDataModel.swift
//  inTarget
//
//  Created by Desta on 12.04.2021.
//

import Foundation
import Firebase

struct UserDataModel {
    var uid : String
    var email : String
    var avatar: String = ""
    var friends : [String] = []
    var groups : [String] = []
    var name : String
    var surName : String
    var tasks : [Task] = []
    
    init(user: User, name : String, surName : String) {
        self.uid = user.uid
        self.email = user.email ?? "NOT email"
        self.name = name
        self.surName = surName
    }
}
