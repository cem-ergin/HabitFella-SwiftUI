//
//  HabitProgress.swift
//  HabitFella
//
//  Created by Cem Ergin on 09/11/2022.
//

import Foundation
import RealmSwift

class HabitProgress: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var habitId: ObjectId
    @Persisted var date: Date
    @Persisted var isDone: Bool = false
    @Persisted var currentGoalCount: Int
    @Persisted var goalCount: Int
}
