//
//  String+Extensions.swift
//  inTarget
//
//  Created by Desta on 21.04.2021.
//

import Foundation

extension String {    
    func changeLabel(count: Int, label: String) -> String {
        
        var resultLabel: String = ""
        
        if count % 10 == 1 {
            if label == "подзадач" {
                resultLabel = "подзадача"
            } else if label == "целей" {
                resultLabel = "цель"
            } else if label == "групп" {
                resultLabel = "группа"
            }
        }
        if count % 10 == 2 ||
                    count % 10 == 3 ||
                    count % 10 == 4 {
            if label == "подзадач" {
                resultLabel = "подзадачи"
            } else if label == "целей" {
                resultLabel = "цели"
            } else if label == "групп" {
                resultLabel = "группы"
            }
        }
        if count % 10 == 5 ||
                    count % 10 == 6 ||
                    count % 10 == 7 ||
                    count % 10 == 8 ||
                    count % 10 == 9 ||
                    count % 10 == 0 {
            if label == "подзадач" {
                resultLabel = "подзадач"
            } else if label == "целей" {
                resultLabel = "целей"
            } else if label == "групп" {
                resultLabel = "групп"
            }
        }
        if count % 100 == 11 ||
                    count % 100 == 12 ||
                    count % 100 == 13 ||
                    count % 100 == 14 {
            if label == "подзадач" {
                resultLabel = "подзадач"
            } else if label == "целей" {
                resultLabel = "целей"
            } else if label == "групп" {
                resultLabel = "групп"
            }
        }
        
        return resultLabel
    }
}
