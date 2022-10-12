//
//  AddHabitViewModelTest.swift
//  HabitFellaTests
//
//  Created by Cem Ergin on 11/10/2022.
//

import XCTest
import RealmSwift
import ViewInspector

@testable import HabitFella
import SwiftUI

final class AddHabitViewModelTest: XCTestCase {
    override func setUp() {
        super.setUp()
        // Use an in-memory Realm identified by the name of the current test.
        // This ensures that each test can't accidentally access or modify the data
        // from other tests or the application itself, and because they're in-memory,
        // there's nothing that needs to be cleaned up.
//        let config = Realm.Configuration(schemaVersion: 9)
//        Realm.Configuration.defaultConfiguration = config
//        testRealmURL()
//        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    @MainActor func test_realmShouldAddGivenHabitToDatabase() {
        let habitName = UUID().uuidString
        let tags: [HabitTag] = [
            HabitTag(value: [
                "tag": UUID().uuidString
            ]),
            HabitTag(value: [
                "tag": UUID().uuidString
            ])
        ]
        let color = Color.green
        let goalCount = 5
        let goalFrequency = FrequencyType.daily
        let goalUnit = UnitType.minute
        let icon = "plus"

        let reminder = Reminder()
        let time = Time()
        time.hour = 13
        time.minute = 56
        reminder.reminderTime = time
        reminder.reminderMessage = UUID().uuidString

        let selectedTimeReminders: [Reminder] = [reminder]

        let addHabitViewModel = AddHabitViewModel()
        addHabitViewModel.habitName = habitName
        addHabitViewModel.tags = tags
        addHabitViewModel.backgroundColor = color
        addHabitViewModel.goalCount = goalCount
        addHabitViewModel.goalFrequency = goalFrequency
        addHabitViewModel.goalUnit = goalUnit
        addHabitViewModel.icon = icon
        addHabitViewModel.selectedTimeReminders = selectedTimeReminders

        let realmManager = RealmManager()

        let result = addHabitViewModel.addHabit(realmManager)

        XCTAssertEqual(result.isSuccess, true)
    }

    @MainActor func test_addHabitCleansTheHabitValues_whenCleanCalled() {
        let habitName = UUID().uuidString
        let tags: [HabitTag] = [
            HabitTag(value: [
                "tag": UUID().uuidString
            ]),
            HabitTag(value: [
                "tag": UUID().uuidString
            ])
        ]
        let color = Color.green
        let goalCount = 5
        let goalFrequency = FrequencyType.daily
        let goalUnit = UnitType.minute
        let icon = "plus"

        let reminder = Reminder()
        let time = Time()
        time.hour = 13
        time.minute = 56
        reminder.reminderTime = time
        reminder.reminderMessage = UUID().uuidString

        let selectedTimeReminders: [Reminder] = [reminder]

        let addHabitViewModel = AddHabitViewModel()
        addHabitViewModel.habitName = habitName
        addHabitViewModel.tags = tags
        addHabitViewModel.backgroundColor = color
        addHabitViewModel.goalCount = goalCount
        addHabitViewModel.goalFrequency = goalFrequency
        addHabitViewModel.goalUnit = goalUnit
        addHabitViewModel.icon = icon
        addHabitViewModel.selectedTimeReminders = selectedTimeReminders

        addHabitViewModel.cleanHabits()

        XCTAssertTrue(addHabitViewModel.habitName.isEmpty)
        XCTAssertTrue(addHabitViewModel.tags.isEmpty)
        XCTAssertEqual(addHabitViewModel.backgroundColor, .blue)
        XCTAssertEqual(addHabitViewModel.goalCount, 1)
        XCTAssertEqual(addHabitViewModel.goalFrequency, FrequencyType.daily)
        XCTAssertEqual(addHabitViewModel.goalUnit, UnitType.times)
        XCTAssertEqual(addHabitViewModel.icon, "book")
        XCTAssertTrue(addHabitViewModel.selectedTimeReminders.isEmpty)
    }
}
