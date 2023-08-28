//
//  SettingsInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/2/23.
//

import XCTest
@testable import SPLYT

final class SettingsInteractorTests: XCTestCase {
    typealias Fixtures = SettingsFixtures
    private var mockService: MockSettingsService!
    private var sut: SettingsInteractor!

    override func setUpWithError() throws {
        self.mockService = MockSettingsService()
        self.sut = SettingsInteractor(service: mockService)
    }
    
    func testInteract_Load() async {
        let result = await sut.interact(with: .load)
        
        let expectedDomain = SettingsDomain(sections: Fixtures.sections)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_SignOut_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .signOut)
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_SignOut_ServiceError() async {
        mockService.signOutSuccess = false
        await load()
        let result = await sut.interact(with: .signOut)
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_SignOut_Success() async {
        await load()
        let result = await sut.interact(with: .signOut)
        
        let expectedDomain = SettingsDomain(sections: Fixtures.sections)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
}

// MARK: - Private

private extension SettingsInteractorTests {
    func load() async {
        _ = await sut.interact(with: .load)
    }
}
