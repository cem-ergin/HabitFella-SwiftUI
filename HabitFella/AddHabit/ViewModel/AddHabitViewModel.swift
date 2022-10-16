//
//  AddHabitViewModel.swift
//  HabitFella
//
//  Created by Cem Ergin on 06/10/2022.
//

import Foundation
import SwiftUI
import RealmSwift

@MainActor class AddHabitViewModel: ObservableObject {
    @Published var habitName: String = ""
    @Published var showHabitNameAlert = false

    @Published var iconPickerPresented = false
    @Published var icon = "book"

    @Published var backgroundColor = Color.blue

    @Published var goalCount = 1
    @Published var goalUnit = UnitType.times
    @Published var goalFrequency = FrequencyType.daily

    @Published var goalNumbers = Array(1...100000)
    @Published var goalNumbersIndex = 0
    @Published var goalUnitTypes = UnitType.allCases.filter({ unitType in
        unitType.rawValue != "steps"
    })
    @Published var goalUnitTypesIndex = 0
    @Published var goalFrequencies = FrequencyType.allCases
    @Published var goalFrequencyIndex = 0

    @Published var data: [[String]] = []
    @Published var selections: [Int] = []

    @Published var repeatIndex = 0
    @Published var repeatWeekIndexes: [RepeatWeekIndexModel] = [RepeatWeekIndexModel(0)]
    @Published var repeatMonthIndexes: Set<Int> = [1]
    @Published var repeatMonthIndexList: [Int] = Array(1...31)

    @Published var weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    @Published var timeOfDayIndex = 0
    @Published var timeOfDays = ["Morning", "Afternoon", "Evening"]

    @Published var tags: [HabitTag] = []

    @Published var selectedDateForReminderTime: Date = Date()
    @Published var popoverPresentedForReminderDate: Bool = false

    @Published var hours = Array(1...24)
    @Published var minutes = Array(1...60)

    @Published var dataForTimeReminder: [[String]] = [
        Array(0...23).map { String($0) },
        Array(0...59).map { String($0) }
    ]
    @Published var selectionsForTimeReminders: [Int] = [13, 56]

    @Published var selectedTimeReminders: [Reminder] = []

    @Published var isNotificationsGranted = false
    @Published var startDate: Date = Date()

    @Published var repeatPresented = false
    @Published var goalPresented = false
    @Published var timeOfDayPresented = false
    @Published var tagsPresented = false

    func saveTimeReminder () {
        let time = Time()
        time.hour = selectionsForTimeReminders[0]
        time.minute = selectionsForTimeReminders[1]
        let message = "Empty for now"
        let reminder = Reminder()
        reminder.reminderTime = time
        reminder.reminderMessage = message
        selectedTimeReminders.append(reminder)
    }

    init() {
        data = [
            goalNumbers.map { "\($0)" },
            goalUnitTypes.map { "\($0)" },
            goalFrequencies.map { "\($0)" }
        ]

        selections = [goalNumbersIndex, goalUnitTypesIndex, goalFrequencyIndex]
    }

    func selectedGoalNumber () -> Int {
        return goalNumbers[goalNumbersIndex]
    }

    func selectedGoalUnitType () -> UnitType {
        return goalUnitTypes[goalUnitTypesIndex]
    }

    func selectedGoalFrequencyType () -> FrequencyType {
        return goalFrequencies[goalFrequencyIndex]
    }

    func selectedText () -> String {
        "\(selectedGoalNumber()) \(selectedGoalUnitType().rawValue) / \(selectedGoalFrequencyType().rawValue)"
    }

    func checkIfHabitIsValid () -> RealmResponse {
        if habitName.isEmpty {
            return RealmResponse(isSuccess: false, message: "Habit name can't be empty", createdHabitId: nil)
        }
        return RealmResponse(isSuccess: true, message: "", createdHabitId: nil)
    }

    func addHabit(_ realmManager: RealmManager) -> RealmResponse {
        let response = checkIfHabitIsValid()
        if !response.isSuccess {
            return response
        }

        let habit = Habit()
        habit.name = habitName

        let _tags = RealmSwift.List<HabitTag>()
        _tags.append(objectsIn: tags)
        habit.tags = _tags

        let uiColor = UIColor(backgroundColor)
        habit.color = HabitColor(value: [
            "red": uiColor.rgba.red,
            "blue": uiColor.rgba.blue,
            "green": uiColor.rgba.green,
            "alpha": uiColor.rgba.alpha
        ])

        habit.goalCount = goalCount
        habit.goalFrequency = goalFrequency.rawValue
        habit.goalUnit = goalUnit.rawValue
        habit.icon = icon

        let _reminders = RealmSwift.List<Reminder>()
        for reminder in selectedTimeReminders {
            _reminders.append(reminder)
        }
        habit.reminders = _reminders
        habit.startDate = Date()

        let realmResponse = realmManager.addHabit(habit: habit)

        if realmResponse.isSuccess {
            setupNotifications()
            if let habitId = realmResponse.createdHabitId {
                addTagsToRealm(habitId, realmManager: realmManager)
            }
        }

        cleanHabits()
        return realmResponse
    }

    func setupNotifications() {
        let notificationManager = NotificationManager()
        for reminder in selectedTimeReminders {
            notificationManager.createLocalNotification(
                title: "HabitFella",
                body: reminder.reminderMessage,
                hour: reminder.reminderTime!.hour,
                minute: reminder.reminderTime!.minute,
                completion: {error in
                print(String(describing: error))
            })
        }
    }

    func addTagsToRealm(_ id: ObjectId, realmManager: RealmManager) {
        var appendingTags: [HabitTag] = []
        for tag in tags {
            let tempTag = HabitTag()
            tempTag.tag = tag.tag
            tempTag.habitId = id
            appendingTags.append(tempTag)
        }
        realmManager.addTags(tags: appendingTags)
    }

    func cleanHabits() {
        habitName = ""
        tags.removeAll()
        backgroundColor = Color.blue
        goalCount = 1
        goalFrequency = FrequencyType.daily
        goalUnit = UnitType.times
        icon = "book"
        selectedTimeReminders.removeAll()
    }

    fileprivate func customDaysPerWeekString() -> String {
        if repeatWeekIndexes.isEmpty {
            return "Custom days per week"
        }
        let sortedIndexes = repeatWeekIndexes.sorted {
            $0.index < $1.index
        }
        var compareList: [Int] = []
        var stringToReturn = ""
        for (index, item) in sortedIndexes.enumerated() {
            if item.index == index {
                compareList.append(index)
            }
            stringToReturn.append("\(weekdays[index]), ")
        }
        stringToReturn = String(stringToReturn.dropLast(2))
        if compareList == [0, 1, 2, 3, 4, 5, 6] {
            stringToReturn = "Every day"
        }
        if compareList == [0, 1, 2, 3, 4] {
            stringToReturn = "Weekdays"
        }
        if compareList == [5, 6] {
            stringToReturn = "Weekends"
        }
        return stringToReturn
    }

    fileprivate func repeatMonthIndexesString() -> String {
        var stringToReturn = ""
        if repeatMonthIndexes.isEmpty {
            return "Custom days per month"
        }
        if repeatMonthIndexes.count == 31 {
            return "Every day"
        }
        let sortedIndexes = repeatMonthIndexes.sorted {
            $0 < $1
        }
        for item in sortedIndexes {
            stringToReturn.append("\(item), ")
        }
        stringToReturn = String(stringToReturn.dropLast(2))
        return stringToReturn
    }

    func repeatText () -> String {
        switch repeatIndex {
        case 0:
            return "Every day"
        case 1:
            return "Weekdays"
        case 2:
            return "Weekends"
        case 3:
            return customDaysPerWeekString()
        case 4:
            return repeatMonthIndexesString()
        default:
            return ""
        }
    }

    func timeOfDayString () -> String {
        switch timeOfDayIndex {
        case 0:
            return "Morning"
        case 1:
            return "Afternoon"
        case 2:
            return "Evening"
        default:
            return ""
        }
    }

    func addTag (_ tag: HabitTag) {
        tags.append(tag)
    }

    func removeTag (_ tagId: ObjectId) {
        tags.removeAll { tag in
            tag._id == tagId
        }
    }

    func tagText () -> String {
        let listOfTagString = tags.map { tag in
            tag.tag
        }
        return listOfTagString.joined(separator: ", ")
    }
}

class RepeatWeekIndexModel: ObservableObject {
    @Published var id = UUID()
    @Published var index: Int = 0

    init(_ index: Int) {
        self.index = index
    }
}
