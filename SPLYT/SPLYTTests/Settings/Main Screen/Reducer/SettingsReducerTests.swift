//
//  SettingsReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/2/23.
//

import XCTest
@testable import SPLYT

final class SettingsReducerTests: XCTestCase {
    typealias Fixtures = SettingsFixtures
    private var interactor: SettingsInteractor!
    private var sut: SettingsReducer!

    override func setUpWithError() throws {
        self.interactor = SettingsInteractor()
        self.sut = SettingsReducer()
    }
    
    func testReduce_Error() {
        let result = sut.reduce(.error)
        XCTAssertEqual(result, .error)
    }
    
    func testReduce_Loaded() async {
        let domain = await interactor.interact(with: .load)
        let result = sut.reduce(domain)
        
        let expectedDisplay = SettingsDisplay(sections: Fixtures.sections)
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
}
