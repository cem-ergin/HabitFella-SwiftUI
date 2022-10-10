//
//  Color.swift
//  HabitFella
//
//  Created by Cem Ergin on 04/10/2022.
//

import Foundation
import RealmSwift

class HabitColor: Object, ObjectKeyIdentifiable {
    @Persisted var red: Float
    @Persisted var green: Float
    @Persisted var blue: Float
    @Persisted var alpha: Float
}
