//
//  RepeatView.swift
//  HabitFella
//
//  Created by Cem Ergin on 06/10/2022.
//

import SwiftUI
import RealmSwift


struct RepeatView: View {
    @ObservedObject var addHabitViewModel: AddHabitViewModel
    
    let texts = ["Every day", "Weekdays", "Weekends", "Custom days per week", "Custom days per month"]
    
    var body: some View {
        List {
            ForEach(0..<texts.count, id: \.self) { i in
                VStack {
                    HStack{
                        Text("\(texts[i])")
                        Spacer()
                        if addHabitViewModel.repeatIndex == i {
                            Image(systemName: "plus")
                        }
                    }
                    if addHabitViewModel.repeatIndex == i && i == 3 {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<addHabitViewModel.weekdays.count) { dayIndex in
                                    Text("\(addHabitViewModel.weekdays[dayIndex])")
                                        .foregroundColor(addHabitViewModel.repeatWeekIndexes.contains { item in
                                            item.index == dayIndex
                                        } ? Color.blue : Color.black)
                                        .onTapGesture {
                                            onWeekdaysTapped(dayIndex)
                                    }
                                }
                            }
                        }
                    }
                    if addHabitViewModel.repeatIndex == i && i == 4 {
                        HStack {
                            MonthDayPickerView(addHabitViewModel: addHabitViewModel).padding()
                        }.frame(width: UIScreen.screenWidth * 0.8, height:UIScreen.screenWidth * 0.9)
                    }
                }.contentShape(Rectangle())
                    .onTapGesture {
                        addHabitViewModel.repeatIndex = i
                    }
            }
        }
    }
    
    fileprivate func onWeekdaysTapped(_ dayIndex: Int) {
        let isContains = addHabitViewModel.repeatWeekIndexes.contains { item in
            item.index == dayIndex
        }
        if isContains {
            addHabitViewModel.repeatWeekIndexes.removeAll { item in
                item.index == dayIndex
            }
        } else {
            addHabitViewModel.repeatWeekIndexes.append(RepeatWeekIndexModel(dayIndex))
        }
    }
}

struct RepeatView_Previews: PreviewProvider {
    static var previews: some View {
        RepeatView(addHabitViewModel: AddHabitViewModel())
    }
}
