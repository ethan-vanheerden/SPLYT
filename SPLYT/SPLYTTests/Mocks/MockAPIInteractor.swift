//
//  MockAPIInteractor.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/23.
//

import Networking
import Mocking
@testable import SPLYT

public final class MockAPIInteractor: APIInteractorType {
    
    public static var shouldThrow = false
    // List because there could be multiple network requests in a row
    public static var mockResponses: [Decodable] = []
    public private(set) static var called = false
    
    public static func performRequest<R: NetworkRequest>(with request: R) async throws -> R.Response {
        called = true
        guard let mockResponse = mockResponses.first as? R.Response,
              !shouldThrow else { throw MockError.someError }
        
        mockResponses.removeFirst()

        return mockResponse
    }
    
    public static func reset() {
        shouldThrow = false
        mockResponses = []
        called = false
    }
}
