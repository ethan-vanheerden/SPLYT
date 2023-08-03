//
//  SettingsNavigationControllerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/2/23.
//

import XCTest
@testable import SPLYT
import SwiftUI

final class SettingsNavigationControllerTests: XCTestCase {
    private var sut: SettingsNavigationController!
    
    override func setUpWithError() throws {
        self.sut = SettingsNavigationController()
    }

    func testInit_StartsOnHistory() {
        let expectedVC = UIHostingController<SettingsView<SettingsViewModel>>.self
        XCTAssertTrue(self.sut.topViewController?.isKind(of: expectedVC) ?? false)
    }
}
