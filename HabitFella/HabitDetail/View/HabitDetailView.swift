//
//  HabitDetailView.swift
//  HabitFella
//
//  Created by Cem Ergin on 17/10/2022.
//

import SwiftUI

struct HabitDetailView: View {
    @StateObject var habitDetailViewModel: HabitDetailViewModel
    @State var heightOfBlue: CGFloat = 0.0
    @State var lastDrag: CGFloat = 0.0
    @State var animation = false
    var frameHeight = UIScreen.screenHeight * 0.9
    var frameWidth = UIScreen.screenWidth * 0.6
    @State var currentSection: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Image(systemName: habitDetailViewModel.habit.icon)
                    .onTapGesture {
                        habitDetailViewModel.updateIcon("plus")
                    }
                Text(habitDetailViewModel.habit.name)
                Text("\(currentSection)/\(habitDetailViewModel.habit.goalCount)")
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
            "goalCount": 5
        ])))
    }
}
