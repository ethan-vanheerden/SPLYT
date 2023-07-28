//
//  HistoryNavigationControllerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/23/23.
//

import XCTest
@testable import SPLYT
import SwiftUI

final class HistoryNavigationControllerTests: XCTestCase {
    private var sut: HistoryNavigationController!

    override func setUpWithError() throws {
        self.sut = HistoryNavigationController()
    }

    func testInit_StartsOnHistory() {
        let expectedVC = UIHostingController<HistoryView<HistoryViewModel>>.self
        XCTAssertTrue(self.sut.topViewController?.isKind(of: expectedVC) ?? false)
    }
}
