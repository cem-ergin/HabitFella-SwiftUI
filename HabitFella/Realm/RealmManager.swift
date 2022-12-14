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
            let config = Realm.Configuration(schemaVersion: 9)
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

    func getHabit(_ id: ObjectId) -> Habit? {
        guard let realm = realm else { return nil }

        let habit = realm.object(ofType: Habit.self, forPrimaryKey: id)
        return habit
    }

    func removeAllHabits() {
        if let realm = realm {
            try? habits.forEach { habit in
                let habitToDelete = realm.objects(Habit.self).filter(NSPredicate(format: "_id == %@", habit._id))
                guard !habitToDelete.isEmpty else { return }
                try realm.write {
                    realm.delete(habitToDelete)
                }
            }
        }
    }

    fileprivate func failureResponse() -> RealmResponse {
        return RealmResponse(isSuccess: false, message: "There was an error", createdHabitId: nil)
    }

    func addHabit(habit: Habit) -> RealmResponse {
        guard let realm = realm else { return failureResponse() }
        do {
            try realm.safeWrite {
                realm.add(habit)
                getHabits()
            }

            return RealmResponse(isSuccess: true, message: "Habit created successfully", createdHabitId: habit._id)
        } catch {
            print("Error adding task to Realm: \(error)")
        }
        return failureResponse()
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

    func addTags(tags: [HabitTag]) {
        guard let realm = realm else { return }
        
        do {
            try realm.safeWrite {
                for tag in tags {
                    realm.add(tag)
                }
                getTags()
            }
        } catch {
            print("Error adding tag to Realm: \(error)")
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

    func updateHabit(habit: Habit) -> RealmResponse {
        guard let realm = realm else {
            print("Couldn't found habit")
            return RealmResponse(isSuccess: false, message: "Couldn't find habit to update", createdHabitId: habit._id)
        }

        do {
            let _habit = realm.object(ofType: Habit.self, forPrimaryKey: habit._id)

            try realm.write {
                if let habitToUpdate = _habit {
                    // TODO: performance improvements: Maybe I can do something like
                    // switch case for each variable of habit
                    // because right now I am passing whole Habit. Which is not necessary

                    habitToUpdate.name = habit.name
                    habitToUpdate.isDone = habit.isDone
                    habitToUpdate.icon = habit.icon
                    habitToUpdate.color = habit.color
                    habitToUpdate.tags = habit.tags
                    habitToUpdate.goalCount = habit.goalCount
                    habitToUpdate.goalUnit = habit.goalUnit
                    habitToUpdate.goalFrequency = habit.goalFrequency
                    habitToUpdate.reminders = habit.reminders
                    habitToUpdate.startDate = habit.startDate
                    habitToUpdate.endDate = habit.endDate

                    self.objectWillChange.send()
                    return RealmResponse(isSuccess: true, message: "Updated successfully", createdHabitId: habit._id)
                }
                return RealmResponse(isSuccess: false, message: "Habit is corrupted", createdHabitId: habit._id)
            }
            return RealmResponse(isSuccess: false, message: "Databse is not ready", createdHabitId: habit._id)
        } catch {
            print("Error updating tag \(habit.id) to Realm: \(error)")
            return RealmResponse(isSuccess: false, message: "\(error)", createdHabitId: habit._id)
        }
    }

    func addOrUpdateHabitProgress(habitProgress: HabitProgress) -> RealmResponse {
        guard let realm = realm else {
            return RealmResponse(isSuccess: false, message: "Couldn't open realm", createdHabitId: habitProgress._id)
        }
        do {
            if let _habitProgress = realm.object(ofType: HabitProgress.self, forPrimaryKey: habitProgress._id) {
                try realm.write {
                    _habitProgress.currentGoalCount = habitProgress.currentGoalCount
                    _habitProgress.goalCount = habitProgress.goalCount
                    _habitProgress.date = habitProgress.date
                    _habitProgress.isDone = habitProgress.isDone

                }
                self.objectWillChange.send()
                return RealmResponse(
                    isSuccess: false,
                    message: "Habit is corrupted",
                    createdHabitId: _habitProgress._id
                )
            } else {
                try realm.write {
                    realm.add(habitProgress)
                }
                return RealmResponse(
                    isSuccess: true,
                    message: "HabitProgress \(habitProgress._id) added",
                    createdHabitId: habitProgress._id
                )
            }
        } catch {
            print("Error updating habitProgress \(habitProgress.id) to Realm: \(error)")
            return RealmResponse(
                isSuccess: false,
                message: "\(error)",
                createdHabitId: habitProgress._id
            )
        }
    }

    func getHabitProgress(habitId: ObjectId, date: Date) -> HabitProgress? {
        guard let realm = realm else { return nil }

        let habitProgress = realm.objects(HabitProgress.self).filter(NSPredicate(format: "habitId == %@", habitId))
        guard !habitProgress.isEmpty else { return nil }

        let _habitProgressToReturn = habitProgress.last { progress in
            Calendar.current.dateComponents([.day], from: progress.date, to: date).day == 0
        }
        return _habitProgressToReturn
    }
}
