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
        XCTAssertEqual(sut.submitFeedback.title, "Submit Feedback")
    }
    
    func testSubtitle() {
        XCTAssertNil(sut.designShowcase.subtitle)
        XCTAssertNil(sut.restPresets.subtitle)
        XCTAssertNil(sut.submitFeedback.subtitle)
    }
    
    func testIsEnabled() {
        XCTAssertTrue(sut.designShowcase.isEnabled)
        XCTAssertTrue(sut.restPresets.isEnabled)
        XCTAssertTrue(sut.submitFeedback.isEnabled)
    }
    
    func testImageName() {
        XCTAssertEqual(sut.designShowcase.imageName, "theatermask.and.paintbrush.fill")
        XCTAssertEqual(sut.restPresets.imageName, "stopwatch.fill")
        XCTAssertEqual(sut.submitFeedback.imageName, "envelope.fill")
    }
    
    func testBackgroundColor() {
        XCTAssertEqual(sut.designShowcase.backgroundColor, .purple)
        XCTAssertEqual(sut.restPresets.backgroundColor, .blue)
        XCTAssertEqual(sut.submitFeedback.backgroundColor, .green)
    }
    
    func testDetail() {
        XCTAssertEqual(sut.designShowcase.detail, .navigation)
        XCTAssertEqual(sut.restPresets.detail, .navigation)
        XCTAssertEqual(sut.submitFeedback.detail, .link(url: "https://forms.gle/bk1b87QBP2ZogKH4A"))
    }
}
