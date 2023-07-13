//
//  HomeInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore

final class HomeInteractorTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockService: MockHomeService!
    private var sut: HomeInteractor!

    override func setUp() async throws {
        self.mockService = MockHomeService()
        self.sut = HomeInteractor(service: mockService)
    }
    
    func testInteract_Load_ServiceError() async {
        mockService.loadRoutinesThrow = true
        let result = await sut.interact(with: .load)
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_Load_Success() async {
        let result = await sut.interact(with: .load)
        let expectedDomain = HomeDomain(routines: WorkoutFixtures.loadedRoutines)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_DeleteWorkout_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .deleteWorkout(id: WorkoutFixtures.legWorkoutId,
                                                             historyFilename: WorkoutFixtures.legWorkoutFilename))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_DeleteWorkout_ServiceError() async {
        await load()
        mockService.saveRoutinesThrow = true
        let result = await sut.interact(with: .deleteWorkout(id: WorkoutFixtures.legWorkoutId,
                                                             historyFilename: WorkoutFixtures.legWorkoutFilename))
        
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.deleteWorkoutHistoryCalled)
        XCTAssertTrue(mockService.saveRoutinesCalled)
    }
    
    func testInteract_DeleteWorkout_BadId_DoesNothing() async {
        await load()
        let result = await sut.interact(with: .deleteWorkout(id: "not-a-workout",
                                                             historyFilename: "bad-filename"))
        let expectedDomain = HomeDomain(routines: WorkoutFixtures.loadedRoutines)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        XCTAssertTrue(mockService.saveRoutinesCalled)
    }
    
    func testInteract_DeleteWorkout_Success() async {
        await load()
        let result = await sut.interact(with: .deleteWorkout(id: WorkoutFixtures.legWorkoutId,
                                                             historyFilename: WorkoutFixtures.legWorkoutFilename))
        
        var routines = WorkoutFixtures.loadedRoutines
        routines.workouts.removeValue(forKey: WorkoutFixtures.legWorkoutId)
        let expectedDomain = HomeDomain(routines: routines)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        XCTAssertTrue(mockService.saveRoutinesCalled)
    }
    
    func testInteract_ToggleDialog_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleDialog(type: .deleteWorkout(id: WorkoutFixtures.legWorkoutId,
                                                                                 historyFilename: WorkoutFixtures.legWorkoutFilename),
                                                            isOpen: true))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleDialog_DeleteDialog_Show_Success() async {
        await load()
        let dialog: HomeDialog = .deleteWorkout(id: WorkoutFixtures.legWorkoutId,
                                                historyFilename: WorkoutFixtures.legWorkoutFilename)
        let result = await sut.interact(with: .toggleDialog(type: dialog, isOpen: true))
        let expectedDomain = HomeDomain(routines: WorkoutFixtures.loadedRoutines)
        
        XCTAssertEqual(result, .dialog(type: dialog, domain: expectedDomain))
    }
    
    func testInteract_ToggleDialog_DeleteDialog_Hide_Success() async {
        await load()
        let dialog: HomeDialog = .deleteWorkout(id: WorkoutFixtures.legWorkoutId,
                                                historyFilename: WorkoutFixtures.legWorkoutFilename)
        _ = await sut.interact(with: .toggleDialog(type: dialog,
                                                   isOpen: true)) // Open dialog to close it
        let result = await sut.interact(with: .toggleDialog(type: dialog,
                                                            isOpen: false))
        let expectedDomain = HomeDomain(routines: WorkoutFixtures.loadedRoutines)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
}

// MARK: - Private

private extension HomeInteractorTests {
    @discardableResult
    func load() async -> HomeDomainResult {
        return await sut.interact(with: .load)
    }
}
