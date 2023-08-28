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
    
    func testSend_Error() async {
        await sut.send(.signOut) // No saved domain
        XCTAssertEqual(sut.viewState, .error)
    }
    
    func testSend_Load() async {
        await sut.send(.load)
        
        let expectedDisplay = SettingsDisplay(sections: Fixtures.sections)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_SignOut() async {
        await load()
        await sut.send(.signOut)
        
        let expectedDisplay = SettingsDisplay(sections: Fixtures.sections)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
}

// MARK: - Private

private extension SettingsViewModelTests {
    func load() async {
        await sut.send(.load)
    }
}
