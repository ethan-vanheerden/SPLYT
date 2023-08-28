//
//  MainViewNavigationControllerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import XCTest
@testable import SPLYT
import SwiftUI

final class MainViewNavigationControllerTests: XCTestCase {
    private var sut: MainViewNavigationController<MockAuthManager>!
    
    override func setUpWithError() throws {
        self.sut = MainViewNavigationController(authManager: MockAuthManager())
    }

    func testInit_StartsOnHistory() {
        let expectedVC = UIHostingController<MainView<MainViewModel, LoginViewModel, MockAuthManager>>.self
        XCTAssertTrue(self.sut.topViewController?.isKind(of: expectedVC) ?? false)
    }
}
