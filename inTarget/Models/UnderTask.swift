//
//  UnderTask.swift
//  inTarget
//
//  Created by Desta on 12.04.2021.
//

import Foundation

struct UnderTask {
    let title: String
    let date: String
    let isCompleted: Bool
    
    init(title: String, date: String, isCompleted: Bool = false) {
        self.title = title
        self.date = date
        self.isCompleted = isCompleted
    }
}
