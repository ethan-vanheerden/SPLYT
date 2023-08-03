//
//  RestPresetsReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/3/23.
//

import XCTest
@testable import SPLYT

final class RestPresetsReducerTests: XCTestCase {
    typealias Fixtures = RestPresetsFixtures
    private var interactor: RestPresetsInteractor!
    private var sut: RestPresetsReducer!

    override func setUpWithError() throws {
        self.interactor = RestPresetsInteractor(service: MockRestPresetsService())
        self.sut = RestPresetsReducer()
    }
    
    func testReduce_Error() {
        let result = sut.reduce(.error)
        XCTAssertEqual(result, .error)
    }
    
    func testReduce_Loaded() async {
        let domain = await interactor.interact(with: .load)
        let result = sut.reduce(domain)
        
        let expectedDisplay = RestPresetsDisplay(presets: Fixtures.presetDisplays)
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
}
