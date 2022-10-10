//
//  AddHabitView.swift
//  HabitFella
//
//  Created by Cem Ergin on 05/10/2022.
//

import SwiftUI
import SymbolPicker
import Popovers

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var addHabitViewModel = AddHabitViewModel()
    @EnvironmentObject var realmManager: RealmManager
    @State var selectedAnchor: Popover.Attributes.Position.Anchor?

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
                    NavigationLink(destination: TimeOfDayPicker(addHabitViewModel: addHabitViewModel)) {
                        HStack {
                            Text("Time of Day")
                            Spacer()
                            Text(addHabitViewModel.timeOfDayString())
                        }
                    }
                    NavigationLink(destination: TagPickerView(addHabitViewModel: addHabitViewModel)) {
                        HStack {
                            Text("Tags")
                            Spacer()
                            Text(addHabitViewModel.tagText())
                        }
                    }
                }

                Section(header: Text("REMINDERS")) {
                    //                    NavigationLink (destination: ()) {
                    HStack {
                        Text("Time")
                        Spacer()
                        ForEach(0..<addHabitViewModel.selectedTimeReminders.count, id: \.self) { index in
                            Button {
                                addHabitViewModel.selectedTimeReminders.remove(at: index)
                            } label: {
                                Text("\(addHabitViewModel.selectedTimeReminders[index].hour) - \(addHabitViewModel.selectedTimeReminders[index].minute)")
                            }.buttonStyle(BorderlessButtonStyle())
                        }

                        Button {
                            DispatchQueue.main.async {
                                addHabitViewModel.popoverPresentedForReminderDate = true
                            }
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.blue)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(.blue)
                                ).popover(present: $addHabitViewModel.popoverPresentedForReminderDate, attributes: {
                                    $0.rubberBandingMode = .none
                                    $0.presentation.animation = .easeInOut
                                    $0.presentation.transition = .opacity
                                    $0.onDismiss = {
                                    }
                                    $0.onContextChange = { context in
                                        self.selectedAnchor = context.selectedAnchor
                                    }
                                    $0.sourceFrameInset = UIEdgeInsets(16)
                                    $0.position = .relative(
                                        popoverAnchors: [
                                            selectedAnchor ?? .bottomRight,
                                            .bottomRight,
                                            .bottomLeft,
                                            .topRight,
                                            .topLeft
                                        ]
                                    )
                                    $0.presentation.animation = .spring(
                                        response: 0.6,
                                        dampingFraction: 0.7,
                                        blendDuration: 1
                                    )

                                    if [.topLeft, .topRight].contains(selectedAnchor) {
                                        $0.presentation.transition = .move(edge: .top)
                                            .combined(with: .opacity)
                                    } else {
                                        $0.presentation.transition = .move(edge: .bottom)
                                            .combined(with: .opacity)
                                    }
                                }) {
                                    ReminderTimePickerView(addHabitViewModel: addHabitViewModel)
                                        .padding()
                                        .foregroundColor(.gray)
                                        .background(.gray)
                                        .cornerRadius(16)
                                }
                        }
                    }
                    //                    }
                    NavigationLink(destination: TimeOfDayPicker(addHabitViewModel: addHabitViewModel)) {
                        HStack {
                            Text("Location")
                            Spacer()
                            Text(addHabitViewModel.timeOfDayString())
                        }
                    }
                }

            }.alert("Habit name shouldn't be empty", isPresented: $addHabitViewModel.showHabitNameAlert) {
                Button("OK", role: .cancel) { }
            }
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
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

struct SwiftUIWrapper<T: View>: UIViewControllerRepresentable {
    let content: () -> T
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: content())
    }
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {}
}
