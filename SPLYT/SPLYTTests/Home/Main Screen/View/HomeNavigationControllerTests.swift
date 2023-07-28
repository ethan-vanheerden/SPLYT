//
//  HomeNavigationControllerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/23/23.
//

import XCTest
@testable import SPLYT
import SwiftUI

final class HomeNavigationControllerTests: XCTestCase {
    private var sut: HomeNavigationController!

    override func setUpWithError() throws {
        self.sut = HomeNavigationController()
    }

    func testInit_StartsOnHome() {
        let expectedVC = UIHostingController<HomeView<HomeViewModel>>.self
        XCTAssertTrue(self.sut.topViewController?.isKind(of: expectedVC) ?? false)
    }
}
