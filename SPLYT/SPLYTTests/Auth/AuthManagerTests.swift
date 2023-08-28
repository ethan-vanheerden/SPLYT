//
//  AuthManagerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import XCTest
@testable import SPLYT

final class AuthManagerTests: XCTestCase {
    private var mockUserAuth: MockUserAuth!
    private var sut: AuthManager!

    override func setUpWithError() throws {
        self.mockUserAuth = MockUserAuth()
        self.sut = AuthManager(userAuth: mockUserAuth)
    }
    
    func testAuthenticatedOnInit() {
        XCTAssertTrue(sut.isAuthenticated)
    }
    
    func testDeauth() {
        mockUserAuth.logout()
        sut = AuthManager(userAuth: mockUserAuth)
        XCTAssertFalse(sut.isAuthenticated)
    }
}
