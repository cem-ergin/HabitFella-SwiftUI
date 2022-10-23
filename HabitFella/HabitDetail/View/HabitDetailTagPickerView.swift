//
//  HabitDetailTagPickerView.swift
//  HabitFella
//
//  Created by Cem Ergin on 22/10/2022.
//

import SwiftUI
import WrappingHStack

struct HabitDetailTagPickerView: View {
    @ObservedObject var habitDetailViewModel: HabitDetailViewModel

    @State var showDialog = false
    @State var showTextEmptyDialog = false
    @State var text = ""

    var body: some View {
        VStack {
            WrappingHStack(habitDetailViewModel.tags, id: \.self, lineSpacing: 8) { tag in
                if !tag.isInvalidated {
                    Text("\(tag.tag)")
                        .padding()
                        .foregroundColor(.white)
                        .background(Capsule().fill(Color(.blue)))
                        .onTapGesture {
                            habitDetailViewModel.removeTag(tag._id)
                        }
                }
            }.animation(.default, value: habitDetailViewModel.tags)
                .padding()
                .border(habitDetailViewModel.tags.isEmpty ? .clear : .blue)
            TextField("Learning", text: $text)
            Button {
                habitDetailViewModel.addTag(HabitTag(value: ["tag": text]))
                text = ""
            } label: {
                Text("Add Tag")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 45)
                    .padding(.vertical, 12)
                    .background(text.isEmpty ? .gray : .blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }.disabled(text.isEmpty)

            if !habitDetailViewModel.name.split(separator: " ").isEmpty {
                VStack {
                    Text("Suggestions").bold()
                    WrappingHStack(habitDetailViewModel.name.split(separator: " "),
                                   id: \.self,
                                   lineSpacing: 8) { tagFromName in
                        if !habitDetailViewModel.tags.contains(where: { tag in
                            tag.tag == tagFromName
                        }) {
                            Text(tagFromName)
                                .padding()
                                .foregroundColor(.white)
                                .background(Capsule().fill(Color(.blue)))
                                .onTapGesture {
                                    habitDetailViewModel.addTag(HabitTag(value: ["tag": tagFromName]))
                                }
                        }
                    }.frame(height: UIScreen.screenHeight * 0.15)
                }
            }
        }.frame(width: UIScreen.screenWidth * 0.9)
    }
}

struct HabitDetailTagPickerView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailTagPickerView(habitDetailViewModel: HabitDetailViewModel(Habit(), RealmManager()))
    }
}
