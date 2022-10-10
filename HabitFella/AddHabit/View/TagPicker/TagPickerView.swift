//
//  TagPicker.swift
//  HabitFella
//
//  Created by Cem Ergin on 08/10/2022.
//

import SwiftUI
import WrappingHStack

struct TagPickerView: View {
    @EnvironmentObject var realmManager: RealmManager
    @ObservedObject var addHabitViewModel: AddHabitViewModel

    @State var showDialog = false
    @State var showTextEmptyDialog = false
    @State var text = ""

    var body: some View {
        VStack(alignment: .leading) {
            WrappingHStack(addHabitViewModel.tags, id: \.self, lineSpacing: 8) { tag in
                if !tag.isInvalidated {
                    Text("\(tag.tag)")
                        .padding()
                        .foregroundColor(.white)
                        .background(Capsule().fill(Color(.blue)))
                        .onTapGesture {
                            addHabitViewModel.removeTag(tag._id)
                        }
                }
            }.frame(height: UIScreen.screenHeight * 0.4)
                .animation(.default, value: addHabitViewModel.tags)
            TextField("Learning", text: $text)
            Button {
                addHabitViewModel.addTag(HabitTag(value: ["tag": text]))
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

            if !addHabitViewModel.habitName.split(separator: " ").isEmpty {
                VStack {
                    Text("Suggestions").bold()
                    WrappingHStack(addHabitViewModel.habitName.split(separator: " "),
                                   id: \.self,
                                   lineSpacing: 8) { tagFromName in
                        Text(tagFromName)
                            .padding()
                            .foregroundColor(.white)
                            .background(Capsule().fill(Color(.blue)))
                            .onTapGesture {
                                realmManager.addTag(tag: HabitTag(value: ["tag": tagFromName]))
                            }
                    }.frame(height: UIScreen.screenHeight * 0.15)
                }
            }
        }.frame(width: UIScreen.screenWidth * 0.9)
    }
}

struct TagPickerView_Previews: PreviewProvider {
    static var previews: some View {
        TagPickerView(addHabitViewModel: AddHabitViewModel())
            .environmentObject(RealmManager())
    }
}
