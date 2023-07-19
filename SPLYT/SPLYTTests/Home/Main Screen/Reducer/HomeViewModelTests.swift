//
//  HomeViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore
@testable import DesignSystem

final class HomeViewModelTests: XCTestCase {
    typealias Fixtures = HomeFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    typealias StateFixtures = WorkoutViewStateFixtures
    private var interactor: HomeInteractor!
    private var sut: HomeViewModel!
    private let workouts: [RoutineTileViewState] = [
        StateFixtures.doLegWorkoutRoutineTile,
        StateFixtures.doFullBodyWorkoutRoutineTile
    ]
    private let plans: [RoutineTileViewState] = [StateFixtures.myPlanRoutineTile]
    
    override func setUpWithError() throws {
        self.interactor = HomeInteractor(service: MockHomeService())
        self.sut = HomeViewModel(interactor: interactor)
    }
    
    func testLoadingOnStart() {
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func testReact_Load() async {
        await sut.send(.load)
        
        let expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                          segmentedControlTitles: Fixtures.segmentedControlTitles,
                                          workouts: workouts,
                                          plans: plans,
                                          fab: Fixtures.fabState,
                                          presentedDialog: nil,
                                          deleteWorkoutDialog: Fixtures.deleteWorkoutDialog,
                                          deletePlanDialog: Fixtures.deletePlanDialog)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testReact_DeleteWorkout_NoSavedDomain_Error() async {
        await sut.send(.deleteWorkout(id: WorkoutFixtures.legWorkoutId))
        
        XCTAssertEqual(sut.viewState, .error)
    }
    
    func testReact_DeleteWorkout_Success() async {
        await load()
        await sut.send(.deleteWorkout(id: WorkoutFixtures.legWorkoutId))
        
        var workouts = workouts
        workouts.remove(at: 0)
        let expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                          segmentedControlTitles: Fixtures.segmentedControlTitles,
                                          workouts: workouts,
                                          plans: plans,
                                          fab: Fixtures.fabState,
                                          presentedDialog: nil,
                                          deleteWorkoutDialog: Fixtures.deleteWorkoutDialog,
                                          deletePlanDialog: Fixtures.deletePlanDialog)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testReact_DeletePlan_Success() async {
        await load()
        await sut.send(.deletePlan(id: WorkoutFixtures.myPlanId))
        
        let expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                          segmentedControlTitles: Fixtures.segmentedControlTitles,
                                          workouts: workouts,
                                          plans: [],
                                          fab: Fixtures.fabState,
                                          presentedDialog: nil,
                                          deleteWorkoutDialog: Fixtures.deleteWorkoutDialog,
                                          deletePlanDialog: Fixtures.deletePlanDialog)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testReact_ToggleDialog_NoSavedDomain_Error() async {
        let dialog: HomeDialog = .deleteWorkout(id: WorkoutFixtures.legWorkoutId)
        await sut.send(.toggleDialog(type: dialog, isOpen: true))
        
        XCTAssertEqual(sut.viewState, .error)
    }
    
    func testReact_ToggleDialog_Delete_Open() async {
        let dialogs: [HomeDialog] = [
            .deleteWorkout(id: WorkoutFixtures.legWorkoutId),
            .deletePlan(id: WorkoutFixtures.myPlanId)
        ]
        
        for dialog in dialogs {
            await load()
            await sut.send(.toggleDialog(type: dialog, isOpen: true))
            
            var expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                              segmentedControlTitles: Fixtures.segmentedControlTitles,
                                              workouts: workouts,
                                              plans: plans,
                                              fab: Fixtures.fabState,
                                              presentedDialog: dialog,
                                              deleteWorkoutDialog: Fixtures.deleteWorkoutDialog,
                                              deletePlanDialog: Fixtures.deletePlanDialog)
            
            XCTAssertEqual(sut.viewState, .main(expectedDisplay))
            
            await sut.send(.toggleDialog(type: dialog, isOpen: false))
            
            expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                              segmentedControlTitles: Fixtures.segmentedControlTitles,
                                              workouts: workouts,
                                              plans: plans,
                                              fab: Fixtures.fabState,
                                              presentedDialog: nil,
                                              deleteWorkoutDialog: Fixtures.deleteWorkoutDialog,
                                              deletePlanDialog: Fixtures.deletePlanDialog)
            
            XCTAssertEqual(sut.viewState, .main(expectedDisplay))
        }
    }
}

// MARK: - Private

private extension HomeViewModelTests {
    func load() async {
        await sut.send(.load)
    }
}
