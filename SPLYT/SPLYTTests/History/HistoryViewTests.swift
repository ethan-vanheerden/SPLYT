//
//  HistoryViewTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/20/22.
//

import XCTest
@testable import SPLYT
import SnapshotTesting
import SwiftUI

final class HistoryViewTests: XCTestCase {
    
    func testHistoryView() {
        let vc = UIHostingController(rootView: HistoryView())
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
}
