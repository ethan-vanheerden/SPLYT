//
//  TimeViewModelTests.swift
//  
//
//  Created by Ethan Van Heerden on 6/12/23.
//

import XCTest
import Core

final class TimeViewModelTests: XCTestCase {
    private var sut = MockTimeViewModel(viewState: 0)
    
    func testStopTime() async {
        await sut.stopTime()
        XCTAssertEqual(sut.secondsElapsed, 0)
    }
}

/// Just a dummy class
final class MockTimeViewModel: TimeViewModel<Int, NoViewEvent> { }
