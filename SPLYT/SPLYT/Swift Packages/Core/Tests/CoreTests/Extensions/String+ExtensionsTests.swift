//
//  String+ExtensionsTests.swift
//  
//
//  Created by Ethan Van Heerden on 6/12/23.
//

import XCTest
@testable import Core

final class String_ExtensionsTests: XCTestCase {
    func testInit_OptionalInt() {
        var int: Int?
        XCTAssertEqual(String(int), "")
        XCTAssertEqual(String(int, defaultDash: true), "--")
        int = 5
        XCTAssertEqual(String(int), "5")
        XCTAssertEqual(String(int, defaultDash: true), "5")
    }
    
    func testInit_OptionalDouble() {
        var double: Double?
        XCTAssertEqual(String(double), "")
        XCTAssertEqual(String(double, defaultDash: true), "--")
        double = 5.0
        XCTAssertEqual(String(double), "5")
        XCTAssertEqual(String(double, defaultDash: true), "5")
        double = 4.8
        XCTAssertEqual(String(double), "4.8")
        XCTAssertEqual(String(double, defaultDash: true), "4.8")
    }
}
