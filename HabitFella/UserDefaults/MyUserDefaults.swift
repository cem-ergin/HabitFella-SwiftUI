//
//  MyUserDefaults.swift
//  HabitFella
//
//  Created by Cem Ergin on 09/10/2022.
//

import Foundation

class MyUserDefaults {

    static let shared = MyUserDefaults()

    func retrieve<T>(_ key: String) -> T? {
        let result = UserDefaults.standard.value(forKey: key)
        return result as? T
    }

    func save<T>(_ key: String, _ data: T) {
        UserDefaults.standard.setValue(data, forKey: key)
    }

    private init() {}
}
