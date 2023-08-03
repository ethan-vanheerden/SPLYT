//
//  RestPresetsInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/3/23.
//

import XCTest
@testable import SPLYT

final class RestPresetsInteractorTests: XCTestCase {
    typealias Fixtures = RestPresetsFixtures
    private var mockService: MockRestPresetsService!
    private var sut: RestPresetsInteractor!

    override func setUpWithError() throws {
        self.mockService = MockRestPresetsService()
        self.sut = RestPresetsInteractor(service: mockService)
    }
    
    func testInteract_Load_Success() async {
        let result = await sut.interact(with: .load)
        
        let expectedDomain = RestPresetsDomain(presets: Fixtures.presets)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        XCTAssertTrue(mockService.getPresetsCalled)
    }
    
    func testInteract_UpdatePresets_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .updatePresets(newPresets: [10, 20, 30]))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_UpdatePresets_Success() async {
        let newPresets = [10, 20, 30]
        await load()
        let result = await sut.interact(with: .updatePresets(newPresets: newPresets))
        
        let expectedDomain = RestPresetsDomain(presets: newPresets)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        XCTAssertTrue(mockService.updatePresetsCalled)
        XCTAssertTrue(mockService.getPresetsCalled)
    }
    
    func testInteract_UpdatePreset_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .updatePreset(index: 0, minutes: 1, seconds: 10))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_UpdatePreset_BadIndex_Error() async {
        await load()
        let result = await sut.interact(with: .updatePreset(index: 3, minutes: 1, seconds: 10))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_UpdatePreset_Success() async {
        await load()
        let result = await sut.interact(with: .updatePreset(index: 1, minutes: 1, seconds: 10)) // 70 sec
        
        var newPresets = Fixtures.presets
        newPresets[1] = 70
        
        let expectedDomain = RestPresetsDomain(presets: newPresets)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        XCTAssertTrue(mockService.updatePresetsCalled)
        XCTAssertTrue(mockService.getPresetsCalled)
    }
}

// MARK: - Private

private extension RestPresetsInteractorTests {
    func load() async {
        _ = await sut.interact(with: .load)
    }
}
