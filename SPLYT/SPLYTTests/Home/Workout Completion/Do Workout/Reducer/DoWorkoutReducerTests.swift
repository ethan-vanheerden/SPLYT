//
//  DoWorkoutReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 6/12/23.
//

import XCTest
@testable import SPLYT
@testable import DesignSystem
@testable import ExerciseCore

final class DoWorkoutReducerTests: XCTestCase {
    typealias StateFixtures = WorkoutViewStateFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    typealias Fixtures = DoWorkoutFixtures
    private let sut = DoWorkoutReducer()
    private var interactor: DoWorkoutInteractor! // Used to contruct the domain object
    
    override func setUpWithError() throws {
        self.interactor = DoWorkoutInteractor(workoutId: WorkoutFixtures.legWorkoutId,
                                              historyFilename: WorkoutFixtures.legWorkoutFilename,
                                              service: MockDoWorkoutService())
    }
    
    func testReducer_Error() {
        let result = sut.reduce(.error)
        XCTAssertEqual(result, .error)
    }
    
    func testReduce_Loaded() async {
        let domain = await loadExercises()
        let result = sut.reduce(domain)
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: Fixtures.legWorkoutStartingGroups,
                                       expandedGroups: [true, false],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(result, .loaded(display))
    }
    
    func testReduce_Dialog_FinishDialog() async {
        await loadExercises()
        let domain = await interactor.interact(with: .toggleDialog(dialog: .finishWorkout, isOpen: true))
        let result = sut.reduce(domain)
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: Fixtures.legWorkoutStartingGroups,
                                       expandedGroups: [true, false],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: .finishWorkout,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(result, .loaded(display))
    }
    
    func testReduce_Exit() async {
        await loadExercises()
        let domain = await interactor.interact(with: .saveWorkout)
        let result = sut.reduce(domain)
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: Fixtures.legWorkoutStartingGroups,
                                       expandedGroups: [true, false],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(result, .exit(display))
    }
}

// MARK: - Private

private extension DoWorkoutReducerTests {
    @discardableResult
    func loadExercises() async -> DoWorkoutDomainResult {
        _ = await interactor.interact(with: .loadWorkout)
        return await interactor.interact(with: .stopCountdown)
    }
}
