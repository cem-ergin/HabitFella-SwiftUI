//
//  ReminderTimePickerViewTest.swift
//  HabitFellaTests
//
//  Created by Cem Ergin on 09/10/2022.
//

import XCTest
import RealmSwift
import ViewInspector

@testable import HabitFella
import SwiftUI

extension ReminderTimePickerView: Inspectable { }

final class ReminderTimePickerViewTest: XCTestCase {
    func test_rendersDatePicker_whenCreated () throws {
        let sut = ReminderTimePickerView()
        let datePicker = try sut.inspect().find(ViewType.DatePicker.self)
        XCTAssertNotNil(datePicker)
    }
}
