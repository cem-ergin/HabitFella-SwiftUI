//
//  HabitView.swift
//  HabitFella
//
//  Created by Cem Ergin on 16/10/2022.
//

import SwiftUI

struct HabitView: View {
    @EnvironmentObject var realmManager: RealmManager
    var habit: Habit
    @State var heightOfBlue: CGFloat = 0.0
    @State var lastDrag: CGFloat = 0.0
    @State var animation = false
    var frameHeight = UIScreen.screenHeight * 0.6
    var frameWidth = UIScreen.screenWidth * 0.4
    @State var currentSection: Int = 0

    var body: some View {
        NavigationLink(destination: HabitDetailView(habitDetailViewModel: HabitDetailViewModel(habit, realmManager))) {
            ZStack(alignment: .bottom) {
                VStack {
                    Image(systemName: habit.icon)
                    Text(habit.name)
                    Text("\(currentSection)/\(habit.goalCount)")
                }
                .frame(width: frameWidth, height: frameHeight)
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(
                            Color(UIColor(
                                red: CGFloat(habit.color!.red),
                                green: CGFloat(habit.color!.green),
                                blue: CGFloat(habit.color!.blue),
                                alpha: CGFloat(habit.color!.alpha
                                              )))
                        ))
                .contentShape(Capsule())
                Color(UIColor(
                    red: CGFloat(habit.color!.red),
                    green: CGFloat(habit.color!.green),
                    blue: CGFloat(habit.color!.blue),
                    alpha: CGFloat(habit.color!.alpha
                                  )))
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
                        self.currentSection = habit.goalCount
                        return
                    }
                    var currentSection = (heightOfBlue / frameHeight) * CGFloat(habit.goalCount)
                    currentSection.round(.toNearestOrAwayFromZero)
                    self.currentSection = Int(currentSection)
                    heightOfBlue += dragValueToAdd
                    lastDrag = dragChange
                })
                    .onEnded({ _ in
                        lastDrag = 0
                        animation = true
                        let dividedHeight = CGFloat(frameHeight) / CGFloat(habit.goalCount)
                        heightOfBlue = Double(dividedHeight * Double(self.currentSection))
                    })
            )
        }.buttonStyle(PlainButtonStyle())
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        HabitView(habit: Habit(value: [
            "name": "Read a Book",
            "icon": "book",
            "color": [
                "red": 0.5,
                "green": 0.5,
                "blue": 0.5,
                "alpha": 0.5
            ],
            "goalCount": 5
        ]))
        .environmentObject(RealmManager())
    }
}
