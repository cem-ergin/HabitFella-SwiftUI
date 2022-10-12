//
//  RealmStatus.swift
//  HabitFella
//
//  Created by Cem Ergin on 12/10/2022.
//

import Foundation
import RealmSwift

struct RealmResponse {
    let isSuccess: Bool
    let message: String
    let createdHabitId: ObjectId?
}
