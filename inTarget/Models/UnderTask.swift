//
//  UnderTask.swift
//  inTarget
//
//  Created by Desta on 12.04.2021.
//

import Foundation

struct UnderTask {
    let randomName : String
    let title: String
    let date: String
    let isCompleted: Bool
    
    init(randomName : String, title: String, date: String, isCompleted: Bool = false) {
        self.randomName = randomName
        self.title = title
        self.date = date
        self.isCompleted = isCompleted
    }
}
