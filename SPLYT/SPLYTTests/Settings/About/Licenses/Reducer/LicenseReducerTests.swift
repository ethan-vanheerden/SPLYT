//
//  LicenseReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 3/11/24.
//

import XCTest
@testable import SPLYT

final class LicenseReducerTests: XCTestCase {
    typealias Fixtures = LicenseFixtures
    private var sut: LicenseReducer!
    private var interactor: LicenseInteractor!

    override func setUpWithError() throws {
        sut = LicenseReducer()
        interactor = LicenseInteractor()
    }
    
    func testReduce_Error() {
        let result = sut.reduce(.error)
        XCTAssertEqual(result, .error)
    }
    
    func testReduce_Loaded() async {
        let domain = await interactor.interact(with: .load)
        let result = sut.reduce(domain)
        
        XCTAssertEqual(result, .loaded(Fixtures.display))
    }
}
