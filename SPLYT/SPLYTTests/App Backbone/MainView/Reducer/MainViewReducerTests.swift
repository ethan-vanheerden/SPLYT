//
//  MainViewReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import XCTest
@testable import SPLYT

final class MainViewReducerTests: XCTestCase {
    private var sut: MainViewReducer!

    override func setUpWithError() throws {
        self.sut = MainViewReducer()
    }
    
    func testReduce_Loaded() {
        let result = sut.reduce(.loaded)
        XCTAssertEqual(result, .loaded)
    }
}
