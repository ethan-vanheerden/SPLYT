//
//  DoWorkoutServiceTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 6/11/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore
import Mocking

final class DoWorkoutServiceTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var cacheInteractor: MockCacheInteractor!
    private var routineCacheInteractor: MockCacheInteractor!
    private var sut: DoWorkoutService!
    
    override func setUpWithError() throws {
        cacheInteractor = MockCacheInteractor()
        routineCacheInteractor = MockCacheInteractor()
        let routineService = CreatedRoutinesService(cacheInteractor: routineCacheInteractor)
        self.sut = DoWorkoutService(cacheInteractor: cacheInteractor,
                                    routineService: routineService)
    }
    
    func testLoadWorkout_FileNoExist_ErrorLoading() {
        routineCacheInteractor.fileExistsThrow = true
        XCTAssertThrowsError(try sut.loadWorkout(workoutId: WorkoutFixtures.legWorkoutId))
    }
    
    func testLoadWorkout_WorkoutNoExist_Error() {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        
        XCTAssertThrowsError(try sut.loadWorkout(workoutId: "not-a-workout"))
    }
    
    func testLoadWorkout_Success() throws {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        
        let result = try sut.loadWorkout(workoutId: WorkoutFixtures.legWorkoutId)
        
        XCTAssertEqual(result, WorkoutFixtures.legWorkout)
    }
    
    func testLoadWorkout_FromPlan_PlanNoExist_Error() {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        
        XCTAssertThrowsError(try sut.loadWorkout(workoutId: WorkoutFixtures.legWorkoutId,
                                                 planId: "not-a-plan"))
    }
    
    func testLoadWorkout_FromPlan_WorkoutNoExist_Error() {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        
        XCTAssertThrowsError(try sut.loadWorkout(workoutId: "not-a-workout",
                                                 planId: WorkoutFixtures.myPlanId))
    }
    
    func testLoadWorkout_FromPlan_Success() throws {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        
        let result = try sut.loadWorkout(workoutId: WorkoutFixtures.fullBodyWorkoutId,
                                         planId: WorkoutFixtures.myPlanId)
        
        XCTAssertEqual(result, WorkoutFixtures.fullBodyWorkout)
    }
    
    func testSaveWorkout_HistoryCacheError() {
        cacheInteractor.loadThrow = true
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = [Workout]()
        
        XCTAssertThrowsError(try sut.saveWorkout(workout: WorkoutFixtures.legWorkout,
                                                 completionDate: WorkoutFixtures.jan_1_2023_0800))
        XCTAssertTrue(routineCacheInteractor.saveCalled)
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_WorkoutNoExist_Error() {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        
        let notFoundWorkout = Workout(id: "id",
                                      name: "Test",
                                      exerciseGroups: [],
                                      createdAt: WorkoutFixtures.dec_27_2022_1000)
        
        XCTAssertThrowsError(try sut.saveWorkout(workout: notFoundWorkout,
                                                 completionDate: WorkoutFixtures.jan_1_2023_0800))
        XCTAssertTrue(routineCacheInteractor.saveCalled)
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_Success() throws {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = WorkoutFixtures.workoutHistories
        let completionDate = WorkoutFixtures.jan_1_2023_0800
        
        try sut.saveWorkout(workout: WorkoutFixtures.legWorkout,
                            completionDate: completionDate)
        
        let workoutHistory = cacheInteractor.stubData as? [WorkoutHistory]
        var workout = WorkoutFixtures.legWorkout
        workout.lastCompleted = completionDate
        let newHistory = WorkoutHistory(id: "\(WorkoutFixtures.legWorkoutId)-2023-01-01T08:00:00Z",
                                     workout: workout)
        var expectedHistories = WorkoutFixtures.workoutHistories
        expectedHistories.insert(newHistory, at: 0)
        
        XCTAssertEqual(workoutHistory, expectedHistories)
        XCTAssertTrue(routineCacheInteractor.saveCalled)
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FromPlan_WorkoutNoExist_Error() {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        
        let notFoundWorkout = Workout(id: "id",
                                      name: "Test",
                                      exerciseGroups: [],
                                      createdAt: WorkoutFixtures.dec_27_2022_1000)
        
        XCTAssertThrowsError(try sut.saveWorkout(workout: notFoundWorkout,
                                                 planId: WorkoutFixtures.myPlanId,
                                                 completionDate: WorkoutFixtures.jan_1_2023_0800))
        XCTAssertTrue(routineCacheInteractor.loadCalled)
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FromPlan_PlanNoExist_Error() {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        
        XCTAssertThrowsError(try sut.saveWorkout(workout: WorkoutFixtures.legWorkout,
                                                 planId: "not-a-plan",
                                                 completionDate: WorkoutFixtures.jan_1_2023_0800))
        XCTAssertTrue(routineCacheInteractor.loadCalled)
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FromPlan_Success() throws {
        routineCacheInteractor.stubFileExists = true
        routineCacheInteractor.stubData = WorkoutFixtures.loadedRoutines
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = WorkoutFixtures.workoutHistories
        let completionDate = WorkoutFixtures.jan_1_2023_0800
        
        try sut.saveWorkout(workout: WorkoutFixtures.legWorkout,
                            planId: WorkoutFixtures.myPlanId,
                            completionDate: completionDate)
        
        let workoutHistory = cacheInteractor.stubData as? [WorkoutHistory]
        var workout = WorkoutFixtures.legWorkout
        workout.lastCompleted = completionDate
        let newHistory = WorkoutHistory(id: "\(WorkoutFixtures.legWorkoutId)-2023-01-01T08:00:00Z",
                                     workout: workout)
        var expectedHistories = WorkoutFixtures.workoutHistories
        expectedHistories.insert(newHistory, at: 0)
        
        XCTAssertEqual(workoutHistory, expectedHistories)
        XCTAssertTrue(routineCacheInteractor.saveCalled)
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
}
