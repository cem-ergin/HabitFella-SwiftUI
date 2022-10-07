//
//  AddHabitViewModel.swift
//  HabitFella
//
//  Created by Cem Ergin on 06/10/2022.
//

import Foundation
import SwiftUI

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
    @Published var selections : [Int] = []
    
    @Published var repeatIndex = 0
    @Published var repeatWeekIndexes : [RepeatWeekIndexModel] = []
    @Published var repeatMonthIndexes : Set<Int> = [1]
    @Published var repeatMonthIndexList : [Int] = Array(1...31)
    

    @Published var weekdays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]

    
    init() {
        data = [
            goalNumbers.map{ "\($0)" },
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
    
    func repeatText () -> String {
        switch repeatIndex {
        case 0:
            return "Every day"
        case 1:
            return "Weekdays"
        case 2:
            return "Weekends"
        case 3:
            if (repeatWeekIndexes.isEmpty) {
                return "Custom days per week"
            }
            let sortedIndexes = repeatWeekIndexes.sorted {
                $0.index < $1.index
            }
            var compareList : [Int] = []
            var stringToReturn = ""
            for (index, item) in sortedIndexes.enumerated() {
                if item.index == index {
                    compareList.append(index)
                    stringToReturn.append("\(weekdays[index]), ")
                }
            }
            stringToReturn = String(stringToReturn.dropLast(2))
            if compareList == [0,1,2,3,4,5,6] {
                stringToReturn = "Every day"
            }
            if compareList == [0,1,2,3,4] {
                stringToReturn = "Weekdays"
            }
            if compareList == [5,6] {
                stringToReturn = "Weekends"
            }
            return stringToReturn
        case 4:
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
            for (_, item) in sortedIndexes.enumerated() {
                stringToReturn.append("\(item), ")
            }
            stringToReturn = String(stringToReturn.dropLast(2))
            return stringToReturn
        default:
            return ""
        }
    }
}



class RepeatWeekIndexModel: ObservableObject {
    @Published var id = UUID()
    @Published var index: Int = 0
    
    init(_ index: Int) {
        self.index = index
    }
}
