//
//  DoPlanViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore
@testable import DesignSystem

final class DoPlanViewModelTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    typealias StateFixtures = WorkoutViewStateFixtures
    private var sut: DoPlanViewModel!
    
    override func setUpWithError() throws {
        let interactor = DoPlanInteractor(planId: WorkoutFixtures.myPlanId,
                                          service: MockDoPlanService())
        sut = DoPlanViewModel(interactor: interactor)
    }
    
    func testLoadingOnInit() {
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func testSend_Load() async {
        await sut.send(.load)
        
        let workouts: [RoutineTileViewState] = [
            StateFixtures.doLegWorkoutRoutineTile,
            StateFixtures.doFullBodyWorkoutRoutineTile
        ]
        let expectedDisplay = DoPlanDisplay(navBar: .init(title: WorkoutFixtures.myPlanName),
                                            workouts: workouts)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
}
