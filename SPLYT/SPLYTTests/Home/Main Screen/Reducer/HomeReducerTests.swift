//
//  HomeReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore
@testable import DesignSystem

final class HomeReducerTests: XCTestCase {
    typealias Fixtures = HomeFixtures
    typealias StateFixtures = WorkoutViewStateFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    private let sut = HomeReducer()
    private var interactor: HomeInteractor!
    private let workouts: [RoutineTileViewState] = [
        StateFixtures.doLegWorkoutRoutineTile,
        StateFixtures.doFullBodyWorkoutRoutineTile
    ]
    private let plans: [RoutineTileViewState] = [StateFixtures.myPlanRoutineTile]
    
    override func setUpWithError() throws {
        self.interactor = HomeInteractor(service: MockHomeService())
    }
    
    func testReduce_Error() {
        let result = sut.reduce(.error)
        XCTAssertEqual(result, .error)
    }
    
    func testReduce_Loaded() async {
        let domain = await interactor.interact(with: .load)
        let result = sut.reduce(domain)
        
        
        let expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                          segmentedControlTitles: Fixtures.segmentedControlTitles,
                                          workouts: workouts,
                                          plans: plans,
                                          fab: Fixtures.fabState,
                                          presentedDialog: nil,
                                          deleteWorkoutDialog: Fixtures.deleteWorkoutDialog,
                                          deletePlanDialog: Fixtures.deletePlanDialog)
        
        XCTAssertEqual(result, .main(expectedDisplay))
    }
    
    func testReduce_Dialog() async {
        let dialogs: [HomeDialog] = [
            .deleteWorkout(id: WorkoutFixtures.legWorkoutId,
                           historyFilename: WorkoutFixtures.legWorkoutFilename),
            .deletePlan(id: WorkoutFixtures.myPlanId)
        ]
        
        for dialog in dialogs {
            _ = await interactor.interact(with: .load)
            let domain = await interactor.interact(with: .toggleDialog(type: dialog, isOpen: true))
            let result = sut.reduce(domain)
            
            let expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                              segmentedControlTitles: Fixtures.segmentedControlTitles,
                                              workouts: workouts,
                                              plans: plans,
                                              fab: Fixtures.fabState,
                                              presentedDialog: dialog,
                                              deleteWorkoutDialog: Fixtures.deleteWorkoutDialog,
                                              deletePlanDialog: Fixtures.deletePlanDialog)
            
            XCTAssertEqual(result, .main(expectedDisplay))
        }
    }
}
