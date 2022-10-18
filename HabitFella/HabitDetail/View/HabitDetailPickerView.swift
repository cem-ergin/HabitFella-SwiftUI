//
//  PickerView.swift
//  HabitFella
//
//  Created by Cem Ergin on 18/10/2022.
//

import SwiftUI

struct HabitDetailPickerView: View {
    var pickerStrings: [String]
    @State var selectedString: [Int]
    var title: String

    var body: some View {
        PickerView(data: [pickerStrings], selections: $selectedString.onChange({ selections in
            print("new selection: \(selections[0])")
        }))
    }
}

struct HabitDetailPickerView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailPickerView(
            pickerStrings: Array(1...33).map { String($0) },
            selectedString: [5],
            title: "Select something"
        )
    }
}
