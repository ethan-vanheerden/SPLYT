//
//  SettingsNavigationRouterTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/20/22.
//

import XCTest
@testable import SPLYT
import Mocking
import DesignSystem
import SwiftUI
@testable import DesignShowcase

final class SettingsNavigationRouterTests: XCTestCase {
    private var mockNavigator: MockNavigator!
    private var sut: SettingsNavigationRouter!
    
    override func setUp() {
        mockNavigator = MockNavigator()
        sut = SettingsNavigationRouter()
        sut.navigator = mockNavigator
    }
    
    func testNavigate_MenuItem_IdIsNotSettingsItem() {
        let menuItemVS = MenuItemViewState(id: 1, title: "TITLE")
        sut.navigate(.menuItem(menuItemVS))
        XCTAssertNil(mockNavigator.stubPushedVC)
    }
    
    func testNavigate_MenuItem_IdIsSettingsItem() {
        let menuItemVS = MenuItemViewState(id: SettingsItem.designShowcase, title: "TITLE")
        sut.navigate(.menuItem(menuItemVS))
        let expectedVC = DesignShowcaseHostingController.self
        XCTAssertNotNil(mockNavigator.stubPushedVC)
        XCTAssertTrue(mockNavigator.stubPushedVC?.isKind(of: expectedVC) ?? false)
    }
}
