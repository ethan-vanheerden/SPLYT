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
    private var sut: SettingsInteractor!

    override func setUpWithError() throws {
        self.sut = SettingsInteractor()
    }
    
    func testInteract_Load() async {
        let result = await sut.interact(with: .load)
        
        let expectedDomain = SettingsDomain(sections: Fixtures.sections)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
}
