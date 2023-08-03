//
//  SettingsViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/2/23.
//

import XCTest
@testable import SPLYT

final class SettingsViewModelTests: XCTestCase {
    typealias Fixtures = SettingsFixtures
    private var interactor: SettingsInteractor!
    private var sut: SettingsViewModel!

    override func setUpWithError() throws {
        self.interactor = SettingsInteractor()
        self.sut = SettingsViewModel(interactor: interactor)
    }
    
    func testLoadingOnInit() {
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func testSend_Load() async {
        await sut.send(.load)
        
        let expectedDisplay = SettingsDisplay(sections: Fixtures.sections)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
}
