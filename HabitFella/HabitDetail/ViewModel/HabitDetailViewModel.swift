//
//  HabitDetailViewModel.swift
//  HabitFella
//
//  Created by Cem Ergin on 17/10/2022.
//

import Foundation
import SwiftUI
import RealmSwift

@MainActor class HabitDetailViewModel: ObservableObject {
    @Published var habit: Habit
    @Published var iconPickerPresented: Bool = false
    var realmManager: RealmManager

    init(_ habit: Habit, _ realmManager: RealmManager) {
        self.habit = Habit(value: habit)
        self.realmManager = realmManager
    }

    var color: Color {
        get {
            Color(
                UIColor(
                    red: CGFloat(habit.color!.red),
                    green: CGFloat(habit.color!.green),
                    blue: CGFloat(habit.color!.blue),
                    alpha: CGFloat(habit.color!.alpha)
                )
            )
        }
        set(color) {
            let habitColor = HabitColor()
            habitColor.green = Float(color.components.green)
            habitColor.red = Float(color.components.red)
            habitColor.blue = Float(color.components.blue)
            habitColor.alpha = Float(color.components.alpha)
            habit.color = habitColor
            updateHabit()
        }
    }

    var icon: String {
        get {
            habit.icon
        }
        set(icon) {
            habit.icon = icon
            updateHabit()
        }
    }

    var name: String {
        get {
            habit.name
        }
        set(name) {
            habit.name = name
            updateHabit()
        }
    }

    var goalCount: Int {
        get {
            habit.goalCount
        }
        set(goalCount) {
            habit.goalCount = goalCount
            updateHabit()
        }
    }

    var goalUnit: String {
        get {
            habit.goalUnit!
        }
        set(goalUnit) {
            habit.goalUnit = goalUnit
            updateHabit()
        }
    }

    var goalFrequency: String {
        get {
            habit.goalFrequency!
        }
        set(goalFrequency) {
            habit.goalFrequency = goalFrequency
            updateHabit()
        }
    }

    var endDate: Date {
        get {
            if habit.endDate == habit.startDate {
                return Date()
            } else {
                return habit.endDate
            }
        }
        set(date) {
            habit.endDate = date
        }
    }

    @State var endDateToggle: Bool = false
    func setEndDateToggle(_ value: Bool) {
        print("value is here and it is: \(value)")
        endDateToggle = value
        if !value {
            endDate = habit.startDate
        }
        self.objectWillChange.send()
    }

    func updateHabit() {
        _ = realmManager.updateHabit(habit: habit)
    }
}
