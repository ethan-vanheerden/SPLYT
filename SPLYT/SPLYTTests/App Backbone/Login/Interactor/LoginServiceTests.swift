//
//  LoginServiceTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import XCTest
@testable import SPLYT

final class LoginServiceTests: XCTestCase {
    typealias Fixtures = LoginFixtures
    private var mockUserAuth: MockUserAuth!
    private var sut: LoginService!
    
    override func setUpWithError() throws {
        self.mockUserAuth = MockUserAuth()
        self.sut = LoginService(userAuth: mockUserAuth)
    }
    
    func testCreateUserSuccess() async {
        let result = await sut.createUser(email: Fixtures.email,
                                          password: Fixtures.password)
        XCTAssertTrue(result)
    }
    
    func testCreateUserFailure() async {
        mockUserAuth.createUserSuccess = false
        let result = await sut.createUser(email: Fixtures.email,
                                          password: Fixtures.password)
        XCTAssertFalse(result)
    }
    
    func testLoginSuccess() async {
        let result = await sut.login(email: Fixtures.email,
                                     password: Fixtures.password)
        XCTAssertTrue(result)
    }
    
    func testLoginFailure() async {
        mockUserAuth.loginSuccess = false
        let result = await sut.login(email: Fixtures.email,
                                     password: Fixtures.password)
        XCTAssertFalse(result)
    }
}
