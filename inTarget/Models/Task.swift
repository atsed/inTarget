//
//  Task.swift
//  inTarget
//
//  Created by Desta on 12.04.2021.
//

import UIKit

struct Task {
    let randomName : String
    let title: String
    let date: String
    let image : String
    //Заменить var на let
    var underTasks: [UnderTask]
    
    init(randomName : String, title: String, date: String, image: String, underTasks: [UnderTask] = []) {
        self.randomName = randomName
        self.title = title
        self.date = date
        self.image = image
        self.underTasks = underTasks
    }
}
