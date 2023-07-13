//
//  HomeViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore

final class HomeViewModelTests: XCTestCase {
    typealias Fixtures = HomeFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var interactor: HomeInteractor!
    private var sut: HomeViewModel!
    
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
                                          workouts: Fixtures.createdWorkoutViewStates,
                                          plans: [], // TODO
                                          fab: Fixtures.fabState,
                                          presentedDialog: nil,
                                          deleteWorkoutDialog: Fixtures.deleteWorkoutDialog,
                                          deletePlanDialog: Fixtures.deletePlanDialog)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testReact_DeleteWorkout_NoSavedDomain_Error() async {
        await sut.send(.deleteWorkout(id: WorkoutFixtures.legWorkoutId,
                                      historyFilename: WorkoutFixtures.legWorkoutFilename))
        
        XCTAssertEqual(sut.viewState, .error)
    }
    
    func testReact_DeleteWorkout_Success() async {
        await load()
        await sut.send(.deleteWorkout(id: WorkoutFixtures.legWorkoutId,
                                      historyFilename: WorkoutFixtures.legWorkoutFilename))
        
        let expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                          segmentedControlTitles: Fixtures.segmentedControlTitles,
                                          workouts: [Fixtures.createdFullBodyWorkoutViewState],
                                          plans: [], // TODO
                                          fab: Fixtures.fabState,
                                          presentedDialog: nil,
                                          deleteWorkoutDialog: Fixtures.deleteWorkoutDialog,
                                          deletePlanDialog: Fixtures.deletePlanDialog)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testReact_ToggleDialog_NoSavedDomain_Error() async {
        let dialog: HomeDialog = .deleteWorkout(id: WorkoutFixtures.legWorkoutId,
                                                historyFilename: WorkoutFixtures.legWorkoutFilename)
        await sut.send(.toggleDialog(type: dialog, isOpen: true))
        
        XCTAssertEqual(sut.viewState, .error)
    }
    
    func testReact_ToggleDialog_Delete_Show() async {
        let dialog: HomeDialog = .deleteWorkout(id: WorkoutFixtures.legWorkoutId,
                                                historyFilename: WorkoutFixtures.legWorkoutFilename)
        await load()
        await sut.send(.toggleDialog(type: dialog, isOpen: true))
        
        let expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                          segmentedControlTitles: Fixtures.segmentedControlTitles,
                                          workouts: Fixtures.createdWorkoutViewStates,
                                          plans: [], // TODO
                                          fab: Fixtures.fabState,
                                          presentedDialog: dialog,
                                          deleteWorkoutDialog: Fixtures.deleteWorkoutDialog,
                                          deletePlanDialog: Fixtures.deletePlanDialog)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testReact_ToggleDialog_Delete_Hide() async {
        let dialog: HomeDialog = .deleteWorkout(id: WorkoutFixtures.legWorkoutId,
                                                historyFilename: WorkoutFixtures.legWorkoutFilename)
        await load()
        await sut.send(.toggleDialog(type: dialog, isOpen: true)) // Open dialog to close it
        await sut.send(.toggleDialog(type: dialog, isOpen: false))
        
        let expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                          segmentedControlTitles: Fixtures.segmentedControlTitles,
                                          workouts: Fixtures.createdWorkoutViewStates,
                                          plans: [], // TODO
                                          fab: Fixtures.fabState,
                                          presentedDialog: nil,
                                          deleteWorkoutDialog: Fixtures.deleteWorkoutDialog,
                                          deletePlanDialog: Fixtures.deletePlanDialog)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
}

// MARK: - Private

private extension HomeViewModelTests {
    func load() async {
        await sut.send(.load)
    }
}
