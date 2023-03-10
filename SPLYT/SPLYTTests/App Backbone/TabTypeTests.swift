//
//  TabTypeTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/20/22.
//

import XCTest
@testable import SPLYT
import SwiftUI
import SnapshotTesting

final class TabTypeTests: XCTestCase {
    func testImageName() {
        let expected = ["dumbbell.fill", "person.crop.circle", "gear"]
        let actual = TabType.allCases.map { $0.imageName }
        XCTAssertEqual(actual, expected)
    }
    
    func testTitle() {
        let expected = ["Home", "Profile", "Settings"]
        let actual = TabType.allCases.map { $0.title }
        XCTAssertEqual(actual, expected)
    }
}
