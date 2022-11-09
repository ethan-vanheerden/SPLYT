//
//  GetAvailableExercisesRequestTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/13/22.
//

import XCTest
@testable import SPLYT
import Networking

final class GetAvailableExercisesRequestsTests: XCTestCase {
    private let sut = GetAvailableExercisesRequest()
    
    func testCreateRequest() {
        let expectedHeaders: [String: String] = [
            "Content-Type": "application/json"
        ]
        var expected = URLRequest(url: ServerURL.createURL(path: "/exercises"))
        expected.httpMethod = HTTPMethod.get.rawValue
        expected.allHTTPHeaderFields = expectedHeaders
        let actual = sut.createRequest()
        
        XCTAssertEqual(actual, expected)
    }
}
