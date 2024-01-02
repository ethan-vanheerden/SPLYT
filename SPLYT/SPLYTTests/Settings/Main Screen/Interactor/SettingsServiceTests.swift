//
//  SettingsServiceTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import XCTest
@testable import SPLYT
import Mocking

final class SettingsServiceTests: XCTestCase {
    private var mockUserAuth: MockUserAuth!
    private var sut: SettingsService!

    override func setUpWithError() throws {
        self.mockUserAuth = MockUserAuth()
        self.sut = SettingsService(userAuth: mockUserAuth)
    }
    
    func testSignOut_Failure() {
        mockUserAuth.logoutSuccess = false
        let result = sut.signOut()
        
        XCTAssertFalse(result)
        XCTAssertTrue(mockUserAuth.signedIn)
    }
    
    func testSignOut_Success() {
        let result = sut.signOut()
        
        XCTAssertTrue(result)
        XCTAssertFalse(mockUserAuth.signedIn)
    }
}
