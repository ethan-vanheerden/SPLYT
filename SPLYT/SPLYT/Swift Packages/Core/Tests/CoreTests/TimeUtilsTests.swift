//
//  TimeUtilsTests.swift
//  
//
//  Created by Ethan Van Heerden on 6/13/23.
//

import XCTest
import Core

final class TimeUtilsTests: XCTestCase {
    private let sut = TimeUtils.self
    private let tenSec = 10
    private let fourMinThritySec = 270
    private let twoHoursTenMinOneSec = 7801

    func testHrMinSec() {
        XCTAssertEqual(sut.hrMinSec(seconds: tenSec), "0:00:10")
        XCTAssertEqual(sut.hrMinSec(seconds: fourMinThritySec), "0:04:30")
        XCTAssertEqual(sut.hrMinSec(seconds: twoHoursTenMinOneSec), "2:10:01")
    }
    
    func testMinSec() {
        XCTAssertEqual(sut.minSec(seconds: tenSec), "00:10")
        XCTAssertEqual(sut.minSec(seconds: fourMinThritySec), "04:30")
        XCTAssertEqual(sut.minSec(seconds: twoHoursTenMinOneSec), "10:01")
    }
    
    func testGetSeconds() {
        
        XCTAssertEqual(sut.getSeconds(minutes: 1, seconds: tenSec), 70)
        XCTAssertEqual(sut.getSeconds(minutes: 2, seconds: fourMinThritySec), 390)
        XCTAssertEqual(sut.getSeconds(minutes: 0, seconds: twoHoursTenMinOneSec), twoHoursTenMinOneSec)
    }
}
