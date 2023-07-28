//
//  HistoryNavigationRouterTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/23/23.
//

import XCTest
@testable import SPLYT
import Mocking
@testable import ExerciseCore
import SwiftUI

final class HistoryNavigationRouterTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockNavigator: MockNavigator!
    private var sut: HistoryNavigationRouter!

    override func setUpWithError() throws {
        self.mockNavigator = MockNavigator()
        self.sut = HistoryNavigationRouter()
        self.sut.navigator = mockNavigator
    }

    func testNavigate_SelectWorkoutHistory() {
        sut.navigate(.selectWorkoutHistory(historyId: WorkoutFixtures.legWorkoutHistoryId))
        
        let expectedVC = UIHostingController<WorkoutDetailsView<WorkoutDetailsViewModel>>.self

        XCTAssertTrue(mockNavigator.stubPresentedVC?.isKind(of: expectedVC) ?? false)
    }
}
