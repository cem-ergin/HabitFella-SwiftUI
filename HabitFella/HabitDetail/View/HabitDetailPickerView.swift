//
//  PickerView.swift
//  HabitFella
//
//  Created by Cem Ergin on 18/10/2022.
//

import SwiftUI

struct HabitDetailPickerView: View {
    var pickerStrings: [String]
    @State var selectedIndex: [Int]
    var title: String
    var someFunction: (_ selection: Int) -> Void

    var body: some View {
        PickerView(data: [pickerStrings], selections: $selectedIndex.onChange({ selections in
            someFunction(selections[0])
        }))
    }
}

struct HabitDetailPickerView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailPickerView(
            pickerStrings: Array(1...33).map { String($0) },
            selectedIndex: [5],
            title: "Select something") {selection in

            }
    }
}
