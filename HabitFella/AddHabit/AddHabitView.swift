//
//  AddHabitView.swift
//  HabitFella
//
//  Created by Cem Ergin on 05/10/2022.
//

import SwiftUI
import SymbolPicker

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var realmManager: RealmManager
    @State private var habitName: String = ""
    @State private var showHabitNameAlert = false
    
    @State private var iconPickerPresented = false
    @State private var icon = "pencil"
    
    
    var body: some View {
        VStack {
            Text("Habit name")
            TextField("Read a book", text: $habitName)
                .border(.primary)
            Button(action: {
                iconPickerPresented = true
            }) {
                HStack {
                    Image(systemName: icon)
                    Text(icon)
                }
            }
            .sheet(isPresented: $iconPickerPresented) {
                SymbolPicker(symbol: $icon)
            }
            
            Button {
                if habitName == "" {
                    showHabitNameAlert = true
                    return
                }
                
                addHabit()
                navigateBack()
            } label: {
                Text("Save")
            }
            
            
            
        }.alert("Habit name shouldn't be empty", isPresented: $showHabitNameAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    fileprivate func navigateBack() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    fileprivate func addHabit() {
        let habit = Habit()
        habit.name = habitName
        realmManager.addHabit(habit: habit)
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView().environmentObject(RealmManager())
    }
}
