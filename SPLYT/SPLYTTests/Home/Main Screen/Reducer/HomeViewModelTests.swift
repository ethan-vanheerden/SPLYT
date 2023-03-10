//
//  HomeViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import XCTest
@testable import SPLYT

final class HomeViewModelTests: XCTestCase {
    typealias Fixtures = HomeFixtures
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
                                          workouts: Fixtures.createdWorkouts,
                                          fab: Fixtures.fabState,
                                          showDialog: nil,
                                          deleteDialog: Fixtures.deleteDialog)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testReact_DeleteWorkout_NoSavedDomain_Error() async {
        await sut.send(.deleteWorkout(id: "leg-workout"))
        
        XCTAssertEqual(sut.viewState, .error)
    }
    
    func testReact_DeleteWorkout_Success() async {
        await load()
        await sut.send(.deleteWorkout(id: "leg-workout"))
        
        let expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                          segmentedControlTitles: Fixtures.segmentedControlTitles,
                                          workouts: [Fixtures.createdFullBodyWorkout],
                                          fab: Fixtures.fabState,
                                          showDialog: nil,
                                          deleteDialog: Fixtures.deleteDialog)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testReact_ToggleDialog_NoSavedDomain_Error() async {
        await sut.send(.toggleDialog(type: .deleteWorkout(id: "leg-workout"), isOpen: true))
        
        XCTAssertEqual(sut.viewState, .error)
    }
    
    func testReact_ToggleDialog_Delete_Show() async {
        await load()
        await sut.send(.toggleDialog(type: .deleteWorkout(id: "leg-workout"), isOpen: true))
        
        let expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                          segmentedControlTitles: Fixtures.segmentedControlTitles,
                                          workouts: Fixtures.createdWorkouts,
                                          fab: Fixtures.fabState,
                                          showDialog: .deleteWorkout(id: "leg-workout"),
                                          deleteDialog: Fixtures.deleteDialog)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testReact_ToggleDialog_Delete_Hide() async {
        await load()
        await sut.send(.toggleDialog(type: .deleteWorkout(id: "leg-workout"), isOpen: true)) // Open dialog to close it
        await sut.send(.toggleDialog(type: .deleteWorkout(id: "leg-workout"), isOpen: false))
        
        let expectedDisplay = HomeDisplay(navBar: Fixtures.navBar,
                                          segmentedControlTitles: Fixtures.segmentedControlTitles,
                                          workouts: Fixtures.createdWorkouts,
                                          fab: Fixtures.fabState,
                                          showDialog: nil,
                                          deleteDialog: Fixtures.deleteDialog)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
}

// MARK: - Private

private extension HomeViewModelTests {
    func load() async {
        await sut.send(.load)
    }
}
