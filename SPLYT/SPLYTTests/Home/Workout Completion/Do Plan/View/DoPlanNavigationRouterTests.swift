//
//  DoPlanNavigationRouterTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore
import Mocking
import SwiftUI

final class DoPlanNavigationRouterTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockNavigator: MockNavigator!
    private var sut: DoPlanNavigationRouter!
    
    override func setUpWithError() throws {
        mockNavigator = MockNavigator()
        sut = DoPlanNavigationRouter(planId: WorkoutFixtures.myPlanId)
        sut.navigator = mockNavigator
    }
    
    func testNavigate_Exit() {
        sut.navigate(.exit)
        XCTAssertTrue(mockNavigator.calledDismiss)
    }
    
    func testNavigate_DoWorkout_NoHistoryFilename() {
        sut.navigate(.doWorkout(workoutId: WorkoutFixtures.fullBodyWorkoutId,
                                historyFilename: nil))
        XCTAssertNil(mockNavigator.stubPushedVC)
    }
    
    func testNavigate_DoWorkout() {
        sut.navigate(.doWorkout(workoutId: WorkoutFixtures.fullBodyWorkoutId,
                                historyFilename: WorkoutFixtures.fullBodyWorkoutFilename))
        
        let expectedVC = UIHostingController<WorkoutPreviewView<DoWorkoutViewModel>>.self
        
        XCTAssertTrue(mockNavigator.stubPushedVC?.isKind(of: expectedVC) ?? false)
    }
}
