//
//  HomeView.swift
//  HabitFella
//
//  Created by Cem Ergin on 05/10/2022.
//

import SwiftUI
import WrappingHStack

struct HomeView: View {
    @EnvironmentObject var realmManager: RealmManager

    var body: some View {
        NavigationView {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(realmManager.habits, id: \._id) { habit in
                        HabitView(habit: habit)
                    }
                }.padding()
            }
//            .scrollDisabled(scrollDisabled)
            //            List {
            //                ForEach(realmManager.habits, id: \._id) { habit in
            //                    if !habit.isInvalidated {
            //                        HStack {
            //                            Text("\(habit.name)")
            //                            Spacer()
            //                            Image(systemName: "trash")
            //                                .foregroundColor(.red)
            //                                .onTapGesture {
            //                                    realmManager.deleteHabit(id: habit._id)
            //                                }
            //                        }
            //                    }
            //                }
            //            }
            .navigationTitle("Home Page")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddHabitView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(RealmManager())
    }
}
