//
//  GetAvailableExercisesRequestTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/13/22.
//

import XCTest
@testable import SPLYT
import Networking
import Mocking

final class GetAvailableExercisesRequestsTests: XCTestCase {
    private var mockUserAuth: MockUserAuth!
    private var sut: GetAvailableExercisesRequest!
    
    override func setUp() async throws {
        self.mockUserAuth = MockUserAuth()
        self.sut = GetAvailableExercisesRequest(userAuth: mockUserAuth)
    }
    
    func testCreateRequest() async throws {
        let expectedHeaders: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(mockUserAuth.stubAuthToken)"
        ]
        
        let url = try XCTUnwrap(URL(string: "https://exercises-2iropnvq6q-uc.a.run.app"))
        var expected = URLRequest(url: url)
        expected.httpMethod = HTTPMethod.get.rawValue
        expected.allHTTPHeaderFields = expectedHeaders
        
        let actual = await sut.createRequest()
        
        XCTAssertEqual(actual, expected)
    }
}
