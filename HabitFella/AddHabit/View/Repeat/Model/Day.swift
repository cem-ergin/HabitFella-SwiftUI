//
//  Day.swift
//  HabitFella
//
//  Created by Cem Ergin on 07/10/2022.
//

import Foundation

class Days {
    let id: String
    var days: [String]
    var dayIndex: Int
    var texts: [String]
    
    init(days: [String] = ["Every day", "Weekdays", "Weekends", "Custom days per week", "Custom days per month"], dayIndex: Int = 0, texts: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]) {
        self.id = UUID().uuidString
        self.days = days
        self.dayIndex = dayIndex
        self.texts = texts
    }
}
