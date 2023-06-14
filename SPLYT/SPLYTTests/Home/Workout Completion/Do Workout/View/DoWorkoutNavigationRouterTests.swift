//
//  DoWorkoutNavigationRouterTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 6/12/23.
//

import XCTest
@testable import SPLYT
import Mocking
import SwiftUI
@testable import ExerciseCore

final class DoWorkoutNavigationRouterTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockNavigator: MockNavigator!
    private var sut: DoWorkoutNavigationRouter!

    override func setUpWithError() throws {
        mockNavigator = MockNavigator()
        let mockService = MockDoWorkoutService()
        let interactor = DoWorkoutInteractor(workoutId: WorkoutFixtures.legWorkoutId,
                                             filename: WorkoutFixtures.legWorkoutFilename,
                                             service: mockService)
        sut = DoWorkoutNavigationRouter(viewModel: DoWorkoutViewModel(interactor: interactor))
        sut.navigator = mockNavigator
    }
    
    func testNavigate_Exit() {
        sut.navigate(.exit)
        XCTAssertTrue(mockNavigator.calledDismissSelf)
    }
    
    func testNavigate_BeginWorkout() {
        sut.navigate(.beginWorkout)
        
        let expectedVC = UIHostingController<DoWorkoutView<DoWorkoutViewModel>>.self
        XCTAssertTrue(mockNavigator.stubPushedVC?.isKind(of: expectedVC) ?? false)
    }
}
