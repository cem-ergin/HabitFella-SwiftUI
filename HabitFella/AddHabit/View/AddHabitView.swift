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
    @StateObject private var addHabitViewModel = AddHabitViewModel()
    @EnvironmentObject var realmManager: RealmManager
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("NAME")) {
                    TextField("Read a book", text: $addHabitViewModel.habitName)
                }.listStyle(.sidebar)
                
                Section(header: Text("STYLE")) {
                    HStack {
                        iconSelectionView().onTapGesture {
                            addHabitViewModel.iconPickerPresented = true
                        }
                        .sheet(isPresented: $addHabitViewModel.iconPickerPresented) {
                            SymbolPicker(symbol: $addHabitViewModel.icon)
                        }
                        
                        VStack {
                            ColorPicker(selection: $addHabitViewModel.backgroundColor) {
                            }.labelsHidden()
                        }.frame(width: 50, height: 50, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(addHabitViewModel.backgroundColor, lineWidth: 0.5))
                    }
                }
                
                Section(header: Text("SETTINGS")) {
                    NavigationLink(destination: RepeatView(addHabitViewModel: addHabitViewModel)) {
                        HStack {
                            Text("Repeat")
                            Spacer()
                            Text(addHabitViewModel.repeatText())
                        }
                    }
                    NavigationLink(destination: GoalPickerView(addHabitViewModel: addHabitViewModel)) {
                        HStack {
                            Text("Goal")
                            Spacer()
                            Text(addHabitViewModel.selectedText())
                        }
                    }
                    NavigationLink (destination: Text("T")) {
                        HStack {
                            Text("Time of Day")
                            Spacer()
                            Text("Any time")
                        }
                    }
                }
                
                Section(header: Text("REMINDERS")) {
                    
                }
                
            }.alert("Habit name shouldn't be empty", isPresented: $addHabitViewModel.showHabitNameAlert) {
                Button("OK", role: .cancel) { }
            }
        }.toolbar {
            ToolbarItem (placement: .navigationBarTrailing) {
                Button {
                    if addHabitViewModel.habitName == "" {
                        addHabitViewModel.showHabitNameAlert = true
                        return
                    }
                    
                    addHabit()
                    navigateBack()
                } label: {
                    Text("Add Habit")
                }
                
            }
        }
    }
    
    fileprivate func navigateBack() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    fileprivate func addHabit() {
        let habit = Habit()
        habit.name = addHabitViewModel.habitName
        realmManager.addHabit(habit: habit)
    }
    
    fileprivate func iconSelectionView() -> some View {
        let rectangleView: some View = RoundedRectangle(cornerRadius: 16)
            .stroke(addHabitViewModel.backgroundColor, lineWidth: 0.5)
        return VStack {
            Image(systemName: addHabitViewModel.icon).font(.system(size: 36))
                .foregroundColor(addHabitViewModel.backgroundColor)
        }.frame(width: 50, height: 50, alignment: .center)
            .overlay(rectangleView)
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView().environmentObject(RealmManager())
    }
}
