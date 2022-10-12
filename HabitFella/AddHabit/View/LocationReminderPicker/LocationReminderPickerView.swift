//
//  LocationReminderPickerView.swift
//  HabitFella
//
//  Created by Cem Ergin on 09/10/2022.
//

import SwiftUI
import MapKit
import MapItemPicker

struct LocationReminderPickerView: View {
    @State private var showingPicker = false

    var body: some View {
        Button("Choose location") {
            showingPicker = true
        }
        .mapItemPicker(isPresented: $showingPicker) { item in
            if let name = item?.name {
                print("Selected \(name)")
            }
        }

    }
}

struct LocationReminderPickerView_Previews: PreviewProvider {
    static var previews: some View {
        LocationReminderPickerView()
    }
}

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
