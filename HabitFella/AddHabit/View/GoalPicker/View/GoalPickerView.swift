//
//  GoalPickerView.swift
//  HabitFella
//
//  Created by Cem Ergin on 06/10/2022.
//

import SwiftUI

struct PickerView: UIViewRepresentable {
    var data: [[String]]
    @Binding var selections: [Int]

    func makeCoordinator() -> PickerView.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<PickerView>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)

        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator

        return picker
    }

    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<PickerView>) {
        for i in 0...(self.selections.count - 1) {
            view.selectRow(self.selections[i], inComponent: i, animated: false)
        }
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: PickerView

        init(_ pickerView: PickerView) {
            self.parent = pickerView
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return self.parent.data.count
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.parent.data[component].count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.parent.data[component][row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selections[component] = row
        }
    }
}

import SwiftUI

struct GoalPickerView: View {
    @ObservedObject var addHabitViewModel: AddHabitViewModel
    
    var body: some View {
        VStack {
            PickerView(data: addHabitViewModel.data, selections: $addHabitViewModel.selections.onChange({ selections in
                addHabitViewModel.goalNumbersIndex = selections[0]
                addHabitViewModel.goalUnitTypesIndex = selections[1]
                addHabitViewModel.goalFrequencyIndex = selections[2]
            }))
        }
    }
}

//    .onChange({ datas in
//        print("list is: \(datas)")
//    })

struct GoalPickerView_Previews: PreviewProvider {
    static var previews: some View {
        GoalPickerView(addHabitViewModel: AddHabitViewModel())
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
