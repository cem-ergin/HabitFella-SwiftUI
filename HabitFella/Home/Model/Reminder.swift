//
//  Reminder.swift
//  HabitFella
//
//  Created by Cem Ergin on 11/10/2022.
//

import Foundation
import RealmSwift

class Reminder: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var reminderTime: Time?
    @Persisted var reminderMessage: String
}
