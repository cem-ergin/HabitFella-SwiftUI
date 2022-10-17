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
        let startDate = Date()

        let addHabitViewModel = AddHabitViewModel()
        addHabitViewModel.habitName = habitName
        addHabitViewModel.tags = tags
        addHabitViewModel.backgroundColor = color
        addHabitViewModel.goalCount = goalCount
        addHabitViewModel.goalFrequency = goalFrequency
        addHabitViewModel.goalUnit = goalUnit
        addHabitViewModel.icon = icon
        addHabitViewModel.selectedTimeReminders = selectedTimeReminders
        addHabitViewModel.startDate = startDate

        let realmManager = RealmManager()

        let result = addHabitViewModel.addHabit(realmManager)

        XCTAssertEqual(result.isSuccess, true)
    }

    @MainActor func test_realmShouldReturnAddedHabitCorrectly() {
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
        let startDate = Date()

        let addHabitViewModel = AddHabitViewModel()
        addHabitViewModel.habitName = habitName
        addHabitViewModel.tags = tags
        addHabitViewModel.backgroundColor = color
        addHabitViewModel.goalCount = goalCount
        let expectedGoalCount = addHabitViewModel.selectedGoalNumber()

        addHabitViewModel.goalFrequency = goalFrequency
        let expectedGoalFrequency = addHabitViewModel.selectedGoalFrequencyType()

        addHabitViewModel.goalUnit = goalUnit
        let expectedGoalUnit = addHabitViewModel.selectedGoalUnitType()

        addHabitViewModel.icon = icon
        addHabitViewModel.selectedTimeReminders = selectedTimeReminders
        addHabitViewModel.startDate = startDate

        let realmManager = RealmManager()
        let result = addHabitViewModel.addHabit(realmManager)
        XCTAssertEqual(result.isSuccess, true)

        let habit = realmManager.getHabit(result.createdHabitId!)
        XCTAssertNotNil(habit)

        let _habit = habit!
        XCTAssertEqual(_habit.name, habitName)
        for (index, tag) in _habit.tags.enumerated() {
            XCTAssertEqual(tag.tag, tags[index].tag)
        }
        XCTAssertEqual(_habit.color!.green, Float(color.components.green))
        XCTAssertEqual(_habit.color!.red, Float(color.components.red))
        XCTAssertEqual(_habit.color!.blue, Float(color.components.blue))
        XCTAssertEqual(_habit.color!.alpha, Float(color.components.alpha))
        XCTAssertEqual(_habit.goalCount, expectedGoalCount)
        XCTAssertEqual(_habit.goalFrequency, expectedGoalFrequency.rawValue)
        XCTAssertEqual(_habit.goalUnit, expectedGoalUnit.rawValue)
        XCTAssertEqual(_habit.icon, icon)
        XCTAssertEqual(
            _habit.startDate.formatted(date: .long, time: .shortened),
            startDate.formatted(date: .long, time: .shortened)
        )
    }

    @MainActor func test_realmShouldAddGivenTagsToDatabase() {
        let habitName = UUID().uuidString
        let tags: [HabitTag] = [
            HabitTag(value: [
                "tag": UUID().uuidString
            ]),
            HabitTag(value: [
                "tag": UUID().uuidString
            ])
        ]

        let addHabitViewModel = AddHabitViewModel()
        addHabitViewModel.habitName = habitName
        addHabitViewModel.tags = tags

        let realmManager = RealmManager()

        let result = addHabitViewModel.addHabit(realmManager)

        XCTAssertTrue(result.isSuccess)

        let realmTags = realmManager.tags
        let firstTag = realmTags.contains { tag in
            tag.tag == tags[0].tag
        }
        let secondTag = realmTags.contains { tag in
            tag.tag == tags[1].tag
        }
        XCTAssertTrue(firstTag)
        XCTAssertTrue(secondTag)
    }

    @MainActor func test_addHabitReturnsFailure_whenHabitNameIsEmpty() {
        let addHabitViewModel = AddHabitViewModel()
        addHabitViewModel.habitName = ""

        let realmManager = RealmManager()
        let result = addHabitViewModel.addHabit(realmManager)

        XCTAssertFalse(result.isSuccess)
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
        let startDate = Date()

        let addHabitViewModel = AddHabitViewModel()
        addHabitViewModel.habitName = habitName
        addHabitViewModel.tags = tags
        addHabitViewModel.backgroundColor = color
        addHabitViewModel.goalCount = goalCount
        addHabitViewModel.goalFrequency = goalFrequency
        addHabitViewModel.goalUnit = goalUnit
        addHabitViewModel.icon = icon
        addHabitViewModel.selectedTimeReminders = selectedTimeReminders
        addHabitViewModel.startDate = startDate

        addHabitViewModel.cleanHabits()

        XCTAssertTrue(addHabitViewModel.habitName.isEmpty)
        XCTAssertTrue(addHabitViewModel.tags.isEmpty)
        XCTAssertEqual(addHabitViewModel.backgroundColor, .blue)
        XCTAssertEqual(addHabitViewModel.goalCount, 1)
        XCTAssertEqual(addHabitViewModel.goalFrequency, FrequencyType.daily)
        XCTAssertEqual(addHabitViewModel.goalUnit, UnitType.times)
        XCTAssertEqual(addHabitViewModel.icon, "book")
        XCTAssertTrue(addHabitViewModel.selectedTimeReminders.isEmpty)
        XCTAssertEqual(addHabitViewModel.startDate, startDate)
    }

    @MainActor func test_addHabitCleansTheHabitValues_whenHabitAdded() {
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
        let startDate = Date()

        let addHabitViewModel = AddHabitViewModel()
        addHabitViewModel.habitName = habitName
        addHabitViewModel.tags = tags
        addHabitViewModel.backgroundColor = color
        addHabitViewModel.goalCount = goalCount
        addHabitViewModel.goalFrequency = goalFrequency
        addHabitViewModel.goalUnit = goalUnit
        addHabitViewModel.icon = icon
        addHabitViewModel.selectedTimeReminders = selectedTimeReminders
        addHabitViewModel.startDate = startDate

        let realmManager = RealmManager()

        let result = addHabitViewModel.addHabit(realmManager)

        XCTAssertEqual(result.isSuccess, true)
        XCTAssertTrue(addHabitViewModel.habitName.isEmpty)
        XCTAssertTrue(addHabitViewModel.tags.isEmpty)
        XCTAssertEqual(addHabitViewModel.backgroundColor, .blue)
        XCTAssertEqual(addHabitViewModel.goalCount, 1)
        XCTAssertEqual(addHabitViewModel.goalFrequency, FrequencyType.daily)
        XCTAssertEqual(addHabitViewModel.goalUnit, UnitType.times)
        XCTAssertEqual(addHabitViewModel.icon, "book")
        XCTAssertTrue(addHabitViewModel.selectedTimeReminders.isEmpty)
        XCTAssertEqual(addHabitViewModel.startDate, startDate)
    }
}
