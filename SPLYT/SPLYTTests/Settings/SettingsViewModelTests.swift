//
//  SettingsViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/20/22.
//

import XCTest
@testable import SPLYT
import DesignSystem

final class SettingsViewModelTests: XCTestCase {
    private var sut: SettingsViewModel!
    
    override func setUp() {
        sut = SettingsViewModel()
    }
    
    func testLoadOnStart() {
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func testSend_Load() async {
        await sut.send(.load)
        XCTAssertEqual(sut.viewState, .main(items: expectedMenuItems()))
    }
}

// MARK: - Private

private extension SettingsViewModelTests {
    func expectedMenuItems() -> [MenuItemViewState] {
        return [
            MenuItemViewState(id: SettingsItem.designShowcase, title: "Design Showcase")
        ]
    }
}
