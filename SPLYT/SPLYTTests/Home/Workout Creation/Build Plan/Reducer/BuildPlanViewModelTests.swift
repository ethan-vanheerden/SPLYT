//
//  BuildPlanViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore
@testable import DesignSystem

final class BuildPlanViewModelTests: XCTestCase {
    typealias Fixtures = BuildPlanFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    typealias StateFixtures = WorkoutViewStateFixtures
    private var interactor: BuildPlanInteractor!
    private var sut: BuildPlanViewModel!
    
    override func setUpWithError() throws {
        interactor = BuildPlanInteractor(service: MockBuildPlanService(),
                                         nameState: .init(name: WorkoutFixtures.myPlanName),
                                         creationDate: WorkoutFixtures.jan_1_2023_0800)
        sut = BuildPlanViewModel(interactor: interactor)
    }
    
    func testLoadingOnInit() {
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func testSend_Load() async {
        await sut.send(.load)
        
        let expectedDisplay = BuildPlanDisplay(workouts: [],
                                               canSave: false,
                                               presentedDialog: nil,
                                               backDialog: Fixtures.backDisloag,
                                               saveDialog: Fixtures.saveDialog,
                                               deleteDialog: Fixtures.deleteDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_NoSavedDomain_Error() async {
        await sut.send(.addWorkout(WorkoutFixtures.legWorkout))
        XCTAssertEqual(sut.viewState, .error)
    }
    
    func testSend_AddWorkout() async {
        await sut.send(.load)
        await sut.send(.addWorkout(WorkoutFixtures.legWorkout))
        
        let expectedDisplay = BuildPlanDisplay(workouts: [StateFixtures.buildLegWorkoutRoutineTile],
                                               canSave: true,
                                               presentedDialog: nil,
                                               backDialog: Fixtures.backDisloag,
                                               saveDialog: Fixtures.saveDialog,
                                               deleteDialog: Fixtures.deleteDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_RemoveWorkout() async {
        await sut.send(.load)
        await sut.send(.addWorkout(WorkoutFixtures.legWorkout))
        await sut.send(.removeWorkout(workoutId: WorkoutFixtures.legWorkoutId))
        
        let expectedDisplay = BuildPlanDisplay(workouts: [],
                                               canSave: false,
                                               presentedDialog: nil,
                                               backDialog: Fixtures.backDisloag,
                                               saveDialog: Fixtures.saveDialog,
                                               deleteDialog: Fixtures.deleteDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_SavePlan() async {
        await sut.send(.load)
        await sut.send(.addWorkout(WorkoutFixtures.legWorkout))
        await sut.send(.savePlan)
        
        let expectedDisplay = BuildPlanDisplay(workouts: [StateFixtures.buildLegWorkoutRoutineTile],
                                               canSave: true,
                                               presentedDialog: nil,
                                               backDialog: Fixtures.backDisloag,
                                               saveDialog: Fixtures.saveDialog,
                                               deleteDialog: Fixtures.deleteDialog)
        
        XCTAssertEqual(sut.viewState, .exit(expectedDisplay))
    }
    
    func testSend_ToggleDialog() async {
        let dialogs: [BuildPlanDialog] = [
            .back,
            .save,
            .deleteWorkout(id: WorkoutFixtures.legWorkoutId)
        ]
        
        for dialog in dialogs {
            await sut.send(.load)
            await sut.send(.toggleDialog(dialog: dialog, isOpen: true)) // Open
            
            var expectedDisplay = BuildPlanDisplay(workouts: [],
                                                   canSave: false,
                                                   presentedDialog: dialog,
                                                   backDialog: Fixtures.backDisloag,
                                                   saveDialog: Fixtures.saveDialog,
                                                   deleteDialog: Fixtures.deleteDialog)
            
            XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
            
            await sut.send(.toggleDialog(dialog: dialog, isOpen: false)) // Close
            
            expectedDisplay = BuildPlanDisplay(workouts: [],
                                               canSave: false,
                                               presentedDialog: nil,
                                               backDialog: Fixtures.backDisloag,
                                               saveDialog: Fixtures.saveDialog,
                                               deleteDialog: Fixtures.deleteDialog)
            
            XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
        }
    }
}
