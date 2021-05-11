//
//  Group.swift
//  inTarget
//
//  Created by Desta on 27.04.2021.
//

import UIKit

struct Group {
    let randomName : String
    let title: String
    let date: String
    let image : String
    var members: [String]
    var underTasks: [UnderTask]
    
    init(randomName : String, title: String, date: String, image: String, members: [String] = [], underTasks: [UnderTask] = []) {
        self.randomName = randomName
        self.title = title
        self.date = date
        self.image = image
        self.members = members
        self.underTasks = underTasks
    }
}
