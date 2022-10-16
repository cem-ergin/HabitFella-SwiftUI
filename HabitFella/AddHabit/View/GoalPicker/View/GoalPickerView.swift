//
//  GoalPickerView.swift
//  HabitFella
//
//  Created by Cem Ergin on 06/10/2022.
//

import SwiftUI

struct GoalPickerView: View {
    @ObservedObject var addHabitViewModel: AddHabitViewModel

    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    PickerView(data: addHabitViewModel.data, selections: $addHabitViewModel.selections.onChange({ selections in
                        addHabitViewModel.goalNumbersIndex = selections[0]
                        addHabitViewModel.goalUnitTypesIndex = selections[1]
                        addHabitViewModel.goalFrequencyIndex = selections[2]
                    }))
                    .background(Color.pink)
                    Text("geometry h: \(geometry.size.height)")
                    Text("geometry w: \(geometry.size.width)")
                }
            }
        }
    }
}

struct GoalPickerView_Previews: PreviewProvider {
    static var previews: some View {
        GoalPickerView(addHabitViewModel: AddHabitViewModel())
    }
}
