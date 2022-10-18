//
//  HabitDetailView.swift
//  HabitFella
//
//  Created by Cem Ergin on 17/10/2022.
//

import SwiftUI
import SymbolPicker

struct HabitDetailView: View {
    @EnvironmentObject var realmManager: RealmManager
    @StateObject var habitDetailViewModel: HabitDetailViewModel
    @State var heightOfBlue: CGFloat = 0.0
    @State var lastDrag: CGFloat = 0.0
    @State var animation = false
//    var frameHeight = UIScreen.screenHeight * 0.9
    var frameHeight = 500.0
//    var frameWidth = UIScreen.screenWidth * 0.6
    var frameWidth = 300.0
    @State var currentSection: Int = 0
    @State var showGoalPicker: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    VStack {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "pencil")
                                .font(.system(size: 12))
                                .padding(-4)
                            Image(systemName: habitDetailViewModel.icon)
                                .padding(6)
                                .border(habitDetailViewModel.color)
                        }
                    }
                    .onTapGesture {
                        habitDetailViewModel.iconPickerPresented = true
                    }
                    .sheet(isPresented: $habitDetailViewModel.iconPickerPresented) {
                        SymbolPicker(symbol: $habitDetailViewModel.icon)
                    }
                }
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "pencil")
                        .font(.system(size: 12))
                    HStack {
                        Spacer()
                        TextField("Habit name", text: $habitDetailViewModel.name)
                            .padding(6)
                            .border(habitDetailViewModel.color)
                        Spacer()
                    }
                }
                Text("\(currentSection)/\(habitDetailViewModel.habit.goalCount)")
                HStack {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12))
                        Text("\(habitDetailViewModel.goalCount)")
                            .padding(6)
                            .border(habitDetailViewModel.color)
                    }
                    .onTapGesture {
                        print("Why is it not showing?")
                        showGoalPicker = true
                    }
                    .sheet(isPresented: $showGoalPicker) {
                        let pickerStrings = Array(1...9000).map { String($0) }
                        HabitDetailPickerView(
                            pickerStrings: pickerStrings,
                            selectedString: [habitDetailViewModel.goalCount],
                            title: "Choose goal count"
                        )
                        .presentationDetents([.medium])
                    }
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12))
                        Text("\(habitDetailViewModel.goalUnit)")
                            .padding(6)
                            .border(habitDetailViewModel.color)
                    }
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12))
                        Text("\(habitDetailViewModel.goalFrequency)")
                            .padding(6)
                            .border(habitDetailViewModel.color)
                    }
                }
            }
            .frame(width: frameWidth, height: frameHeight)
            .overlay(
                Capsule(style: .continuous)
                    .stroke(
                        habitDetailViewModel.color
                    )
            )
            .contentShape(Capsule())
            habitDetailViewModel.color
            .frame(width: frameWidth, height: heightOfBlue)
            .animation(.easeInOut, value: animation)
            .opacity(0.3)
        }
        .clipShape(Capsule())
        .contentShape(Capsule())
        .gesture(DragGesture()
            .onChanged({ drag in
                animation = false
                let dragChange = drag.translation.height * -1
                let dragValueToAdd = dragChange - lastDrag
                if heightOfBlue + dragValueToAdd <= 0 {
                    heightOfBlue = 0
                    self.currentSection = 0
                    return
                }
                if heightOfBlue + dragValueToAdd > frameHeight {
                    heightOfBlue = frameHeight
                    self.currentSection = habitDetailViewModel.habit.goalCount
                    return
                }
                var currentSection = (heightOfBlue / frameHeight) * CGFloat(habitDetailViewModel.habit.goalCount)
                currentSection.round(.toNearestOrAwayFromZero)
                self.currentSection = Int(currentSection)
                heightOfBlue += dragValueToAdd
                lastDrag = dragChange
            })
                .onEnded({ _ in
                    lastDrag = 0
                    animation = true
                    let dividedHeight = CGFloat(frameHeight) / CGFloat(habitDetailViewModel.habit.goalCount)
                    heightOfBlue = Double(dividedHeight * Double(self.currentSection))
                })
        )
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(habitDetailViewModel: HabitDetailViewModel(Habit(value: [
            "name": "Read a Book",
            "icon": "book",
            "color": [
                "red": 0.5,
                "green": 0.5,
                "blue": 0.5,
                "alpha": 0.5
            ],
            "goalCount": 5,
            "goalUnit": "times",
            "goalFrequency": "Every day"
        ]), RealmManager()))
        .environmentObject(RealmManager())
    }
}