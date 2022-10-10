//
//  MonthDayPickerView.swift
//  HabitFella
//
//  Created by Cem Ergin on 07/10/2022.
//

import SwiftUI
import RealmSwift
import WrappingHStack

struct MonthDayPickerView: View {
    @ObservedObject var addHabitViewModel: AddHabitViewModel

    var body: some View {
        WrappingHStack(addHabitViewModel.repeatMonthIndexList, id: \.self) { index in
            Text("\(index)")
                .frame(width: UIScreen.screenWidth / 10, height: UIScreen.screenWidth / 10)
                .background(Rectangle().stroke())
                .padding(.bottom, 8)
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .foregroundColor(addHabitViewModel.repeatMonthIndexes.contains(index) ? .blue : .black)
                .onTapGesture {
                    if addHabitViewModel.repeatMonthIndexes.contains(index) {
                        if addHabitViewModel.repeatMonthIndexes.count != 1 {
                            addHabitViewModel.repeatMonthIndexes.remove(index)
                        }
                    } else {
                        addHabitViewModel.repeatMonthIndexes.insert(index)
                    }
                }
        }
    }
}

struct MonthDayPickerView_Previews: PreviewProvider {
    static var previews: some View {
        MonthDayPickerView(addHabitViewModel: AddHabitViewModel())
    }
}
