//
//  Habit.swift
//  HabitFella
//
//  Created by Cem Ergin on 05/10/2022.
//

import Foundation
import Realm
import RealmSwift

class Habit: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var isDone: Bool = false
    @Persisted var icon: String
    @Persisted var color: HabitColor?
    @Persisted var tags: List<String>
    @Persisted var goalCount: Int
    @Persisted var goalUnit: UnitType.RawValue?
    @Persisted var goalFrequency: FrequencyType.RawValue?
    @Persisted var reminderTime: Time?
    @Persisted var reminderMessage: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
}

