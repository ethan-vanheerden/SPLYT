//
//  BuildPlanReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore

final class BuildPlanReducerTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    typealias Fixtures = BuildPlanFixtures
    private var interactor: BuildPlanInteractor!
    private var sut: BuildPlanReducer!
    
    override func setUp() async throws {
        interactor = BuildPlanInteractor(service: MockBuildPlanService(),
                                         nameState: .init(name: WorkoutFixtures.myPlanName),
                                         creationDate: WorkoutFixtures.jan_1_2023_0800)
        sut = BuildPlanReducer()
    }
    
    func testReduce_Error() {
        let result = sut.reduce(.error)
        XCTAssertEqual(result, .error)
    }
    
    func testReduce_Loaded_EmptyWorkouts() async {
        let domain = await interactor.interact(with: .load)
        let result = sut.reduce(domain)
        
        let expectedDisplay = BuildPlanDisplay(workouts: [],
                                               canSave: false,
                                               presentedDialog: nil,
                                               backDialog: Fixtures.backDisloag,
                                               saveDialog: Fixtures.saveDialog,
                                               deleteDialog: Fixtures.deleteDialog)
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
    
    func testReduce_Loaded_NonEmptyWorkouts() async {
        let domain = await load()
        let result = sut.reduce(domain)
        
        let expectedDisplay = BuildPlanDisplay(workouts: [Fixtures.fullBodyWorkoutRoutineTile],
                                               canSave: true,
                                               presentedDialog: nil,
                                               backDialog: Fixtures.backDisloag,
                                               saveDialog: Fixtures.saveDialog,
                                               deleteDialog: Fixtures.deleteDialog)
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
    
    func testReduce_Dialog() async {
        let dialogs: [BuildPlanDialog] = [
            .back,
            .save,
            .deleteWorkout(id: WorkoutFixtures.fullBodyWorkoutId)
        ]
        
        for dialog in dialogs {
            await load()
            let domain = await interactor.interact(with: .toggleDialog(dialog: dialog, isOpen: true))
            let result = sut.reduce(domain)
            
            let expectedDisplay = BuildPlanDisplay(workouts: [Fixtures.fullBodyWorkoutRoutineTile],
                                                   canSave: true,
                                                   presentedDialog: dialog,
                                                   backDialog: Fixtures.backDisloag,
                                                   saveDialog: Fixtures.saveDialog,
                                                   deleteDialog: Fixtures.deleteDialog)
            
            XCTAssertEqual(result, .loaded(expectedDisplay))
        }
    }
    
    func testReduce_Exit() async {
        await load()
        let domain = await interactor.interact(with: .savePlan)
        let result = sut.reduce(domain)
        
        let expectedDisplay = BuildPlanDisplay(workouts: [Fixtures.fullBodyWorkoutRoutineTile],
                                               canSave: true,
                                               presentedDialog: nil,
                                               backDialog: Fixtures.backDisloag,
                                               saveDialog: Fixtures.saveDialog,
                                               deleteDialog: Fixtures.deleteDialog)
        
        XCTAssertEqual(result, .exit(expectedDisplay))
    }
}

// MARK: - Private

private extension BuildPlanReducerTests {
    @discardableResult
    /// Loads a starting workout as well
    func load() async -> BuildPlanDomainResult {
        _ = await interactor.interact(with: .load)
        return await interactor.interact(with: .addWorkout(workout: WorkoutFixtures.fullBodyWorkout))
    }
}
