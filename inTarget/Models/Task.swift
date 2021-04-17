//
//  Task.swift
//  inTarget
//
//  Created by Desta on 12.04.2021.
//

import UIKit

struct Task {
    var title: String
    var date: String
    var image : String
    var underTasks: Array<UnderTask> = []
    init(title: String, date: String, image: String) {
        self.title = title
        self.date = date
        self.image = image
    }
}
