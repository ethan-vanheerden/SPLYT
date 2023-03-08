//
//  NameWorkoutViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 1/10/23.
//

import XCTest
@testable import SPLYT
import DesignSystem

final class NameWorkoutViewModelTests: XCTestCase {
    private let sut = NameWorkoutViewModel()
    
    func testViewState() {
        let viewState = sut.viewState
        let expectedNavBar = NavigationBarViewState(title: "CREATE WORKOUT")
        
        XCTAssertEqual(viewState.navBar, expectedNavBar)
    }
}
