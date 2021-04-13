//
//  Task.swift
//  inTarget
//
//  Created by Desta on 12.04.2021.
//

import UIKit

struct Task {
    var title: String = ""
    var image: UIImage = #imageLiteral(resourceName: "artur")
    var date: String = ""
    var description: String = ""
    var underTasks: Array<UnderTask> = []
}
