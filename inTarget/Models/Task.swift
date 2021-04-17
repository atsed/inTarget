//
//  Task.swift
//  inTarget
//
//  Created by Desta on 12.04.2021.
//

import UIKit

struct Task {
    let title: String
    let date: String
    let image : String
    let underTasks: [UnderTask] = []
    
    init(title: String, date: String, image: String) {
        self.title = title
        self.date = date
        self.image = image
    }
}
