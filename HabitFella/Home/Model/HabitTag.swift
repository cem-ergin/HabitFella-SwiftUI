//
//  HabitTag.swift
//  HabitFella
//
//  Created by Cem Ergin on 08/10/2022.
//

import Foundation
import RealmSwift

class HabitTag: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var habitId: ObjectId
    @Persisted var tag: String
    @Persisted var isEnabled: Bool = true
}
