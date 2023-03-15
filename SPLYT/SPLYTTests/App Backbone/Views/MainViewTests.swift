//
//  MainViewTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/20/22.
//

import XCTest
@testable import SPLYT
import SnapshotTesting
import SwiftUI

final class MainViewTests: XCTestCase {
    
    func testMainView_Workouts() {
        let vc = UIHostingController(rootView: MainView(viewModel: MainViewModel()))
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
    
    func testMainView_History() {
        let vc = UIHostingController(rootView: MainView(viewModel: MainViewModel(), selectedTab: .history))
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
    
    func testMainView_Settings() {
        let vc = UIHostingController(rootView: MainView(viewModel: MainViewModel(), selectedTab: .settings))
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
}
