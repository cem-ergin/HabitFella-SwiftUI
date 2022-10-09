//
//  ReminderTimePickerView.swift
//  HabitFella
//
//  Created by Cem Ergin on 09/10/2022.
//

import SwiftUI
import UserNotifications

struct ReminderTimePickerView: View {
    @ObservedObject var addHabitViewModel: AddHabitViewModel
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var notificationManager: NotificationManager = NotificationManager()
    
    var body: some View {
        Group {
            switch notificationManager.authorizationStatus {
            case .authorized:
                VStack {
                    HStack {
                        Button {
                            addHabitViewModel.popoverPresentedForReminderDate = false
                        } label: {
                            Text("Cancel")
                        }.foregroundColor(.white)
                        Spacer()
                        Button {
                            var dateComponents = DateComponents()
                            dateComponents.hour = addHabitViewModel.selectionsForTimeReminders[0]
                            dateComponents.minute = addHabitViewModel.selectionsForTimeReminders[1]
                           
                            addHabitViewModel.saveTimeReminder()
                            addHabitViewModel.popoverPresentedForReminderDate = false
                        } label: {
                            Text("Save")
                        }.foregroundColor(.white)
                        
                        Button("Print Notifications") {
                        }
                        .foregroundColor(.blue)
                        .padding().foregroundColor(.white)
                    }
                    PickerView(data: addHabitViewModel.dataForTimeReminder, selections: $addHabitViewModel.selectionsForTimeReminders)
                }
            case .denied:
                VStack {
                    Button {
                        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    } label: {
                        Text("Please Enable Notification Permission In Settings").foregroundColor(.white)
                    }
                }
            default:
                VStack {
                    Button {
                        notificationManager.requestAuthorization()
                    } label: {
                        Text("Grant Notification Authorization").foregroundColor(.white)
                    }.foregroundColor(.white)
                }
            }
            
        }.onAppear(perform: notificationManager.reloadAuthorizationStatus)
            .onChange(of: notificationManager.authorizationStatus) { authorizationStatus in
                switch authorizationStatus {
                case .notDetermined:
                    notificationManager.requestAuthorization()
                case .authorized:
                    notificationManager.reloadLocalNotifications()
                default:
                    break
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                notificationManager.reloadAuthorizationStatus()
            }
    }
}

struct ReminderTimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderTimePickerView(addHabitViewModel: AddHabitViewModel())
    }
}
