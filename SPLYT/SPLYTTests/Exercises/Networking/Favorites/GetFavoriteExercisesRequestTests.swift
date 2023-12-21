//
//  GetFavoriteExercisesRequestTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/21/23.
//

import XCTest
@testable import SPLYT
import Mocking
import Networking

final class GetFavoriteExercisesRequestTests: XCTestCase {
    private var mockUserAuth: MockUserAuth!
    private var sut: GetFavoriteExercisesRequest!

    override func setUpWithError() throws {
        self.mockUserAuth = MockUserAuth()
        self.sut = GetFavoriteExercisesRequest(userAuth: mockUserAuth)
    }
    
    func testCreateRequest() async throws {
        let expectedHeaders: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(mockUserAuth.stubAuthToken)"
        ]
        
        let url = try XCTUnwrap(URL(string: "https://favorites-2iropnvq6q-uc.a.run.app"))
        var expected = URLRequest(url: url)
        expected.httpMethod = HTTPMethod.get.rawValue
        expected.allHTTPHeaderFields = expectedHeaders
        
        let actual = await sut.createRequest()
        
        XCTAssertEqual(actual, expected)
    }
}
