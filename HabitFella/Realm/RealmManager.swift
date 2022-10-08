//
//  RealmManager.swift
//  HabitFella
//
//  Created by Cem Ergin on 05/10/2022.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private(set) var realm: Realm?
    @Published var habits: [Habit] = []
    @Published var tags: [HabitTag] = []
    
    init() {
        openRealm()
        getHabits()
        getTags()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 7)
            Realm.Configuration.defaultConfiguration = config
            realm = try Realm()
        } catch {
            print("Error opening Realm", error)
        }
    }
    
    func getHabits() {
        if let realm = realm {
            let allHabits = realm.objects(Habit.self)
            habits.removeAll()
            allHabits.forEach { habit in
                habits.append(habit)
            }
        }
    }
    
    func removeAllHabits() {
        if let realm = realm {
            try! habits.forEach { habit in
                let habitToDelete = realm.objects(Habit.self).filter(NSPredicate(format: "_id == %@", habit._id))
                guard !habitToDelete.isEmpty else { return }
                try realm.write {
                    realm.delete(habitToDelete)
                }
            }
        }
    }
    
    func addHabit(habit: Habit) {
        if let realm = realm {
            do {
                try realm.write {
                    realm.add(habit)
                    getHabits()
                }
            } catch {
                print("Error adding task to Realm: \(error)")
            }
        }
    }
    
    func deleteHabit(id: ObjectId) {
        if let realm = realm {
            do {
                let habitToDelete = realm.objects(Habit.self).filter(NSPredicate(format: "_id == %@", id))
                guard !habitToDelete.isEmpty else { return }
                try realm.write {
                    realm.delete(habitToDelete)
                    getHabits()
                }
            } catch {
                print("Error deleting task \(id) to Realm: \(error)")
            }
        }
    }
    
    
    func getTags() {
        if let realm = realm {
            let allTags = realm.objects(HabitTag.self)
            tags.removeAll()
            allTags.forEach { tag in
                tags.append(tag)
            }
        }
    }
    
    func addTag(tag: HabitTag) {
        if let realm = realm {
            do {
                try realm.write {
                    realm.add(tag)
                    getTags()
                }
            } catch {
                print("Error adding tag to Realm: \(error)")
            }
        }
    }
    
    func deleteTag(id: ObjectId) {
        if let realm = realm {
            do {
                let tagToDelete = realm.objects(HabitTag.self).filter(NSPredicate(format: "_id == %@", id))
                guard !tagToDelete.isEmpty else { return }
                try realm.write {
                    realm.delete(tagToDelete)
                    getTags()
                }
            } catch {
                print("Error deleting tag \(id) to Realm: \(error)")
            }
        }
    }
}
