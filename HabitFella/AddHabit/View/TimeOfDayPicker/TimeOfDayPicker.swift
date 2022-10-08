//
//  TimeOfDayPicker.swift
//  HabitFella
//
//  Created by Cem Ergin on 08/10/2022.
//

import SwiftUI

struct TimeOfDayPicker: View {
    @ObservedObject var addHabitViewModel: AddHabitViewModel
    
    var body: some View {
        List {
            ForEach(0..<addHabitViewModel.timeOfDays.count, id: \.self) { i in
                HStack{
                    Text("\(addHabitViewModel.timeOfDays[i])")
                    Spacer()
                    if addHabitViewModel.timeOfDayIndex == i {
                        Image(systemName: "plus")
                    }
                }.contentShape(Rectangle())
                    .onTapGesture {
                        addHabitViewModel.timeOfDayIndex = i
                    }
            }
        }
    }
}

struct TimeOfDayPicker_Previews: PreviewProvider {
    static var previews: some View {
        TimeOfDayPicker(addHabitViewModel: AddHabitViewModel())
    }
}
