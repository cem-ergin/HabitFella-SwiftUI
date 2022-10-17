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

    var color: Color {
        get {
            Color(UIColor(
                red: CGFloat(habit.color!.red),
                green: CGFloat(habit.color!.green),
                blue: CGFloat(habit.color!.blue),
                alpha: CGFloat(habit.color!.alpha
                              )))
        }
        set {
            habit.color = HabitColor()
        }
    }

    init(_ habit: Habit) {
        self.habit = habit
    }

    func updateIcon(_ icon: String) {
        habit.icon = icon
        self.objectWillChange.send()
    }


}
