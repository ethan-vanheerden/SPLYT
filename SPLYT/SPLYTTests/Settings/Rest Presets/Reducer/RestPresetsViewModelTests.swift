//
//  RestPresetsViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/3/23.
//

import XCTest
@testable import SPLYT

final class RestPresetsViewModelTests: XCTestCase {
    typealias Fixtures = RestPresetsFixtures
    private var sut: RestPresetsViewModel!

    override func setUpWithError() throws {
        let interactor = RestPresetsInteractor(service: MockRestPresetsService())
        self.sut = RestPresetsViewModel(interactor: interactor)
    }

    func testLoadingOnInit() {
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func testSend_Load() async {
        await sut.send(.load)
        
        let expectedDisplay = RestPresetsDisplay(presets: Fixtures.presetDisplays)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_Error() async {
        await sut.send(.updatePresets(newPresets: [10, 20, 30]))
        XCTAssertEqual(sut.viewState, .error)
    }
    
    func testSend_UpdatePresets() async {
        await sut.send(.load)
        await sut.send(.updatePresets(newPresets: [10, 20, 30]))
        
        let newPresets: [PresetDisplay] = [
            .init(index: 0, title: "00:10", preset: 10, minutes: 0, seconds: 10),
            .init(index: 1, title: "00:20", preset: 20, minutes: 0, seconds: 20),
            .init(index: 2, title: "00:30", preset: 30, minutes: 0, seconds: 30)
        ]
        
        let expectedDisplay = RestPresetsDisplay(presets: newPresets)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_UpdatePreset() async {
        await sut.send(.load)
        await sut.send(.updatePreset(index: 0, minutes: 3, seconds: 10))
        
        var newPresets = Fixtures.presetDisplays
        newPresets[0] = .init(index: 0, title: "03:10", preset: 190, minutes: 3, seconds: 10)
        
        let expectedDisplay = RestPresetsDisplay(presets: newPresets)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
}
