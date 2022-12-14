//
//  HabitDetailView.swift
//  HabitFella
//
//  Created by Cem Ergin on 17/10/2022.
//

import SwiftUI
import SymbolPicker
import RealmSwift

struct HabitDetailView: View {
    @EnvironmentObject var realmManager: RealmManager
    @StateObject var habitDetailViewModel: HabitDetailViewModel
    @State var heightOfBlue: CGFloat = 0.0
    @State var lastDrag: CGFloat = 0.0
    @State var animation = false
    var frameHeight = UIScreen.screenHeight * 0.9
//    var frameHeight = 500.0
    var frameWidth = UIScreen.screenWidth * 0.6
//    var frameWidth = 300.0
    @State var currentSection: Int = 0
    @State var showGoalPicker: Bool = false
    @State var showUnitPicker: Bool = false
    @State var showFrequencyPicker: Bool = false
    @State var showTagPicker: Bool = false

    @State var localToggle: Bool = false
    var body: some View {
        ZStack {
            Image("space")
                .resizable()
                .frame(width: UIScreen.screenWidth * 0.7, height: UIScreen.screenHeight * 0.95)
                .clipShape(Capsule())

            ZStack(alignment: .bottom) {
                HabitDetail(
                    realmManager: _realmManager,
                    habitDetailViewModel: habitDetailViewModel,
                    heightOfBlue: heightOfBlue,
                    lastDrag: lastDrag,
                    animation: animation,
                    frameHeight: frameHeight,
                    frameWidth: frameWidth,
                    currentSection: currentSection,
                    showGoalPicker: showGoalPicker,
                    showUnitPicker: showUnitPicker,
                    showFrequencyPicker: showFrequencyPicker,
                    showTagPicker: showTagPicker
                )

                Image("space")
                    .resizable()
                .frame(width: frameWidth, height: heightOfBlue)
                .animation(.easeInOut, value: animation)
                .opacity(0.3)
            }
            .clipShape(Capsule())
            .contentShape(Capsule())
            .gesture(DragGesture()
                .onChanged { drag in
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
                }
                    .onEnded({ _ in
                        lastDrag = 0
                        animation = true
                        let dividedHeight = CGFloat(frameHeight) / CGFloat(habitDetailViewModel.habit.goalCount)
                        heightOfBlue = Double(dividedHeight * Double(self.currentSection))
                    })
            )
//            Color.red
//                .frame(width: 350.0, height: 550.0)
//                .clipShape(Capsule())
        }
    }
}

struct HabitDetail: View {
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
    @State var showUnitPicker: Bool = false
    @State var showFrequencyPicker: Bool = false
    @State var showTagPicker: Bool = false
    @State var localToggle: Bool = false

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "pencil")
                    .font(.system(size: 12))
                    .padding(-4)
                HStack {
                    if habitDetailViewModel.tags.isEmpty {
                        Text("NO-TAG-FOUND")
                    } else {
                        ForEach(habitDetailViewModel.tags, id: \._id) { tag in
                            Text("#\(tag.tag) ")
                        }
                    }
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(habitDetailViewModel.color, lineWidth: 0.5))
            .onTapGesture {
                showTagPicker = true
            }
            .sheet(isPresented: $showTagPicker) {
                HabitDetailTagPickerView(habitDetailViewModel: habitDetailViewModel)
            }

            VStack {
                ColorPicker(selection: $habitDetailViewModel.color) {
                }.labelsHidden()
            }.frame(width: 50, height: 50, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(habitDetailViewModel.color, lineWidth: 0.5))
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
                    showGoalPicker = true
                }
                .sheet(isPresented: $showGoalPicker) {
                    let pickerStrings = Array(1...9000).map { String($0) }
                    HabitDetailPickerView(
                        pickerStrings: pickerStrings,
                        selectedIndex: [
                            Int(pickerStrings.firstIndex(of: String(habitDetailViewModel.goalCount)) ?? 0)
                        ],
                        title: "Choose",
                        someFunction: { selection in
                            habitDetailViewModel.goalCount = Int(pickerStrings[selection])!
                        }
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
                .onTapGesture {
                    showUnitPicker = true
                }
                .sheet(isPresented: $showUnitPicker) {
                    let unitTypes = UnitType.allCases.map { type in
                        type.rawValue
                    }
                    HabitDetailPickerView(
                        pickerStrings: unitTypes,
                        selectedIndex: [
                            Int(unitTypes.firstIndex(of: String(habitDetailViewModel.goalUnit)) ?? 0)
                        ],
                        title: "Choose",
                        someFunction: { selection in
                            habitDetailViewModel.goalUnit = unitTypes[selection]
                        }
                    )
                    .presentationDetents([.medium])
                }
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "pencil")
                        .font(.system(size: 12))
                    Text("\(habitDetailViewModel.goalFrequency)")
                        .padding(6)
                        .border(habitDetailViewModel.color)
                }
                .onTapGesture {
                    showFrequencyPicker = true
                }
                .sheet(isPresented: $showFrequencyPicker) {
                    let frequencyTypes = FrequencyType.allCases.map { type in
                        type.rawValue
                    }
                    HabitDetailPickerView(
                        pickerStrings: frequencyTypes,
                        selectedIndex: [
                            Int(frequencyTypes.firstIndex(of: String(habitDetailViewModel.goalFrequency)) ?? 0)
                        ],
                        title: "Choose",
                        someFunction: { selection in
                            habitDetailViewModel.goalFrequency = frequencyTypes[selection]
                        }
                    )
                    .presentationDetents([.medium])
                }
            }
            HStack {
                Text("Start Date")
                Text("").padding()
                Text("\(habitDetailViewModel.habit.startDate)")
            }
            HStack {
                Text(habitDetailViewModel.endDateToggle ? "End Date" : "")
                if localToggle {
                    DatePicker(
                        "Choose end date",
                        selection: $habitDetailViewModel.endDate,
                        displayedComponents: [.date]
                    )
                }
                Toggle(!localToggle ? "Use end date" : "", isOn: $localToggle)
                    .onChange(of: localToggle) { newValue in
                        habitDetailViewModel.setEndDateToggle(newValue)
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
        .background(Capsule().fill(Color.white))
        .contentShape(Capsule())
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let habit = Habit()
        habit.name = "Read a Book"
        habit.icon = "book"

        let habitColor = HabitColor()
        habitColor.green = 0.5
        habitColor.red = 0.5
        habitColor.blue = 0.5
        habitColor.alpha = 1.0
        habit.color = habitColor

        habit.goalCount = 5
        habit.goalUnit = "times"
        habit.goalFrequency = "Every day"
        let _tags = RealmSwift.List<HabitTag>()
        _tags.append(objectsIn: [
            HabitTag(value: ["tag": "tag 1"]),
            HabitTag(value: ["tag": "tag 2"])
        ])
        habit.tags = _tags
        return HabitDetailView(habitDetailViewModel: HabitDetailViewModel(habit, RealmManager()))
        .environmentObject(RealmManager())
    }
}
