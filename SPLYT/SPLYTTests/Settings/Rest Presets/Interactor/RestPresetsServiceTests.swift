//
//  RestPresetsServiceTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/3/23.
//

import XCTest
@testable import SPLYT
import Mocking

final class RestPresetsServiceTests: XCTestCase {
    typealias Fixtures = RestPresetsFixtures
    private var mockUserSettings: MockUserSettings!
    private var sut: RestPresetsService!

    override func setUpWithError() throws {
        self.mockUserSettings = MockUserSettings()
        self.sut = RestPresetsService(userSettings: mockUserSettings)
    }

    func testGetPresets() {
        let result = sut.getPresets()
        XCTAssertEqual(result, Fixtures.presets)
    }
    
    func testGetPresets_WrongType_Fallback_Presets() {
        mockUserSettings.mockDefaults[.restPresets] = "wrong type"
        let result = sut.getPresets()
        
        let updatedPresets = mockUserSettings.mockDefaults[.restPresets] as? [Int]
        
        XCTAssertEqual(result, Fixtures.presets)
        XCTAssertEqual(updatedPresets, Fixtures.presets)
    }
    
    func testUpdatePresets() {
        let newPresets = [10, 20, 30]
        sut.updatePresets(newPresets: newPresets)
        let result = sut.getPresets()
        
        XCTAssertEqual(result, newPresets)
    }
}
