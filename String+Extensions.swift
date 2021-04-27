//
//  String+Extensions.swift
//  inTarget
//
//  Created by Desta on 21.04.2021.
//

import Foundation

extension String {
    func underTasksString(value: Int) -> String {
//        var underTasksLabel: String
//        if "1".containsString("\(self % 10)")      {underTasksLabel = "день"}
//        if "234".containsString("\(self % 10)")    {dayString = "дня" }
        //        if "567890".containsString("\(self % 10)") {dayString = "дней"}
        //        if 11...14 ~= self % 100                   {dayString = "дней"}
        //        return "\(self) " + dayString
        var underTasksLabel: String = ""
        
        if value == 1 {
            underTasksLabel = "подзадача"
        }
        if value % 10 == 2 ||
                    value % 10 == 3 ||
                    value % 10 == 4 {
            underTasksLabel = "подзадачи"
        }
        if value % 10 == 5 ||
                    value % 10 == 6 ||
                    value % 10 == 7 ||
                    value % 10 == 8 ||
                    value % 10 == 9 ||
                    value % 10 == 0 {
            underTasksLabel = "подзадач"
        }
        if value % 100 == 11 ||
                    value % 100 == 12 ||
                    value % 100 == 13 ||
                    value % 100 == 14 {
            underTasksLabel = "подзадач"
        }
        
        return underTasksLabel
    }
}
