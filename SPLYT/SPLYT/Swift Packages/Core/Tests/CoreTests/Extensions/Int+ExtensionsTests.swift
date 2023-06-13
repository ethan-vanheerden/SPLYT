//
//  Int+ExtensionsTests.swift
//  
//
//  Created by Ethan Van Heerden on 6/12/23.
//

import XCTest
@testable import Core

final class Int_ExtensionsTests: XCTestCase {
    func testInit_OptionalDouble() {
        var double: Double?
        XCTAssertNil(Int(double))
        double = 5.0
        XCTAssertEqual(Int(double), 5)
        double = 4.8
        XCTAssertEqual(Int(double), 4)
    }
}
