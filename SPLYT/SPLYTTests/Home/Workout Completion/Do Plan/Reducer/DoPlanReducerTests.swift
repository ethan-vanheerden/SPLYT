//
//  DoPlanReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore
@testable import DesignSystem

final class DoPlanReducerTests: XCTestCase {
    typealias StateFixtures = WorkoutViewStateFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var interactor: DoPlanInteractor!
    private var sut: DoPlanReducer!
    
    override func setUp() async throws {
        interactor = DoPlanInteractor(planId: WorkoutFixtures.myPlanId,
                                          service: MockDoPlanService())
        sut = DoPlanReducer()
    }
    
    func testReduce_Error() {
        let result = sut.reduce(.error)
        XCTAssertEqual(result, .error)
    }
    
    func testReduce_Loaded() async {
        let domain = await interactor.interact(with: .load)
        let result = sut.reduce(domain)
        
        let workouts: [RoutineTileViewState] = [
            StateFixtures.doLegWorkoutRoutineTile,
            StateFixtures.doFullBodyWorkoutRoutineTile
        ]
        let expectedDisplay = DoPlanDisplay(navBar: .init(title: WorkoutFixtures.myPlanName),
                                            workouts: workouts)
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
}
