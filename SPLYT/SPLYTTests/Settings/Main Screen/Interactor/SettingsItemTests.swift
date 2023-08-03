//
//  SettingsItemTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/3/23.
//

import XCTest
@testable import SPLYT
import DesignSystem

final class SettingsItemTests: XCTestCase {
    typealias sut = SettingsItem
    
    func testTitle() {
        XCTAssertEqual(sut.designShowcase.title, "Design Showcase")
        XCTAssertEqual(sut.restPresets.title, "Rest Presets")
    }
    
    func testSubtitle() {
        XCTAssertNil(sut.designShowcase.subtitle)
        XCTAssertNil(sut.restPresets.subtitle)
    }
    
    func testIsEnabled() {
        XCTAssertTrue(sut.designShowcase.isEnabled)
        XCTAssertTrue(sut.restPresets.isEnabled)
    }
    
    func testImageName() {
        XCTAssertEqual(sut.designShowcase.imageName, "theatermask.and.paintbrush.fill")
        XCTAssertEqual(sut.restPresets.imageName, "stopwatch.fill")
    }
    
    func testBackgroundColor() {
        XCTAssertEqual(sut.designShowcase.backgroundColor, .purple)
        XCTAssertEqual(sut.restPresets.backgroundColor, .blue)
    }
}
