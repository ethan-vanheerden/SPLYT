//
//  UpdateFavoriteExercisesRequestTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/21/23.
//

import XCTest
@testable import SPLYT
import Mocking
import Networking

final class UpdateFavoriteExercisesRequestTests: XCTestCase {
    private var mockUserAuth: MockUserAuth!
    private let requestBody = UpdateFavoriteExerciseRequestBody(exerciseId: "test",
                                                                isFavorite: true)
    private var sut: UpdateFavoriteExerciseRequest!
    
    override func setUpWithError() throws {
        self.mockUserAuth = MockUserAuth()
        self.sut = UpdateFavoriteExerciseRequest(requestBody: requestBody,
                                                 userAuth: mockUserAuth)
    }
    
    func testCreateRequest() async throws {
        let expectedHeaders: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(mockUserAuth.stubAuthToken)"
        ]
        
        let url = try XCTUnwrap(URL(string: "https://favorites-2iropnvq6q-uc.a.run.app"))
        var expected = URLRequest(url: url)
        expected.httpMethod = HTTPMethod.post.rawValue
        expected.allHTTPHeaderFields = expectedHeaders
        expected.httpBody = try JSONEncoder().encode(requestBody) // TODO: It looks like the equatable doesn't look at this field
        
        let actual = await sut.createRequest()
        
        XCTAssertEqual(actual, expected)
    }
}
