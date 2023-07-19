import XCTest
@testable import ExerciseCore
import Mocking

final class CreatedRoutinesServiceTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var cacheInteractor: MockCacheInteractor!
    private var sut: CreatedRoutinesService!
    private let emptyRoutines = CreatedRoutines(workouts: [:], plans: [:])
    
    override func setUp() async throws {
        self.cacheInteractor = MockCacheInteractor()
        self.sut = CreatedRoutinesService(cacheInteractor: cacheInteractor)
    }
    
    func testLoadRoutines_CacheError() {
        cacheInteractor.fileExistsThrow = true
        XCTAssertThrowsError(try sut.loadRoutines())
    }
    
    func testLoadRoutines_FileNoExists_SavesEmptyRoutines() throws {
        let result = try sut.loadRoutines()
        
        XCTAssertEqual(result, emptyRoutines)
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testLoadRoutines_FileExists_LoadsRoutines() throws {
        setupRoutines()
        
        let result = try sut.loadRoutines()
        
        XCTAssertEqual(result, WorkoutFixtures.loadedRoutines)
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testSaveRoutines_CacheError() {
        cacheInteractor.saveThrow = true
        
        XCTAssertThrowsError(try sut.saveRoutines(WorkoutFixtures.loadedRoutines))
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testSaveRoutines_Success() throws {
        try sut.saveRoutines(WorkoutFixtures.loadedRoutines)
        
        let savedData = cacheInteractor.stubData as? CreatedRoutines
        
        XCTAssertEqual(savedData, WorkoutFixtures.loadedRoutines)
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testLoadWorkout_CacheError() {
        setupRoutines()
        cacheInteractor.loadThrow = true
        XCTAssertThrowsError(try sut.loadWorkout(workoutId: WorkoutFixtures.legWorkoutId,
                                                 planId: nil))
    }
    
    func testLoadWorkout_WorkoutNotFound_Error() throws {
        setupRoutines()
        XCTAssertThrowsError(try sut.loadWorkout(workoutId: "doesn't-exist", planId: nil))
    }
    
    func testLoadWorkout_Success() throws {
        setupRoutines()
        let result = try sut.loadWorkout(workoutId: WorkoutFixtures.legWorkoutId, planId: nil)
        
        XCTAssertEqual(result, WorkoutFixtures.legWorkout)
    }
    
    func testLoadWorkout_FromPlan_PlanNotFound_Error() throws {
        setupRoutines()
        XCTAssertThrowsError(try sut.loadWorkout(workoutId: WorkoutFixtures.legWorkoutId,
                                                 planId: "doesn't-exist"))
    }
    
    func testLoadWorkout_FromPlan_WorkoutNotFound_Error() throws {
        setupRoutines()
        XCTAssertThrowsError(try sut.loadWorkout(workoutId: "doesn't-exist",
                                                 planId: WorkoutFixtures.myPlanId))
    }
    
    func testLoadWorkout_FromPlan_Success() throws {
        setupRoutines()
        let result = try sut.loadWorkout(workoutId: WorkoutFixtures.legWorkoutId,
                                         planId: WorkoutFixtures.myPlanId)
        
        XCTAssertEqual(result, WorkoutFixtures.legWorkout)
    }
    
    func testSaveWorkout_CacheError() {
        setupRoutines()
        cacheInteractor.loadThrow = true
        XCTAssertThrowsError(try sut.saveWorkout(workout: WorkoutFixtures.legWorkout,
                                                 planId: nil,
                                                 lastCompletedDate: WorkoutFixtures.jan_1_2023_0800))
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_Success() throws {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = emptyRoutines
        var workout = WorkoutFixtures.legWorkout
        
        try sut.saveWorkout(workout: workout,
                            planId: nil,
                            lastCompletedDate: WorkoutFixtures.jan_1_2023_0800)
        
        let savedData = cacheInteractor.stubData as? CreatedRoutines
        workout.lastCompleted = WorkoutFixtures.jan_1_2023_0800
        let expectedWorkouts: [String: Workout] = [
            WorkoutFixtures.legWorkoutId: workout
        ]
        
        XCTAssertEqual(savedData?.workouts, expectedWorkouts)
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FromPlan_PlanNotFound_Error() {
        setupRoutines()
        XCTAssertThrowsError(try sut.saveWorkout(workout: WorkoutFixtures.legWorkout,
                                                 planId: "doesn't-exist",
                                                 lastCompletedDate: WorkoutFixtures.jan_1_2023_0800))
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FromPlan_WorkoutNotFound_Error() {
        setupRoutines()
        let notFoundWorkout = Workout(id: "id",
                                      name: "Test",
                                      exerciseGroups: [],
                                      createdAt: WorkoutFixtures.dec_27_2022_1000)
        
        XCTAssertThrowsError(try sut.saveWorkout(workout: notFoundWorkout,
                                                 planId: "doesn't-exist",
                                                 lastCompletedDate: WorkoutFixtures.jan_1_2023_0800))
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FromPlan_Success() throws {
        setupRoutines()
        var workout = WorkoutFixtures.legWorkout_WorkoutStart
        
        try sut.saveWorkout(workout: WorkoutFixtures.legWorkout_WorkoutStart,
                            planId: WorkoutFixtures.myPlanId,
                            lastCompletedDate: WorkoutFixtures.jan_1_2023_0800)
        
        let savedData = cacheInteractor.stubData as? CreatedRoutines
        workout.lastCompleted = WorkoutFixtures.jan_1_2023_0800
        var expectedPlan = WorkoutFixtures.myPlan
        expectedPlan.workouts = [
            workout,
            WorkoutFixtures.fullBodyWorkout
        ]
        expectedPlan.lastCompleted = WorkoutFixtures.jan_1_2023_0800
        let expectedPlans: [String: Plan] = [
            WorkoutFixtures.myPlanId: expectedPlan
        ]
        
        XCTAssertEqual(savedData?.plans, expectedPlans)
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testSaveWorkout_FromPlan_NoLastCompleted_Success() throws {
        setupRoutines()
        
        try sut.saveWorkout(workout: WorkoutFixtures.fullBodyWorkout,
                            planId: WorkoutFixtures.myPlanId,
                            lastCompletedDate: nil)
        
        let savedData = cacheInteractor.stubData as? CreatedRoutines
        var expectedPlan = WorkoutFixtures.myPlan
        expectedPlan.workouts = [
            WorkoutFixtures.legWorkout,
            WorkoutFixtures.fullBodyWorkout
        ]
        let expectedPlans: [String: Plan] = [
            WorkoutFixtures.myPlanId: expectedPlan
        ]
        
        XCTAssertEqual(savedData?.plans, expectedPlans)
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
    
    func testLoadPlan_CacheError() {
        setupRoutines()
        cacheInteractor.loadThrow = true
        XCTAssertThrowsError(try sut.loadPlan(id: WorkoutFixtures.myPlanId))
    }
    
    func testLoadPlan_PlanNotFound_Error() {
        setupRoutines()
        XCTAssertThrowsError(try sut.loadPlan(id: "doesn't-exist"))
    }
    
    func testLoadPlan_Success() throws {
        setupRoutines()
        let result = try sut.loadPlan(id: WorkoutFixtures.myPlanId)
        
        XCTAssertEqual(result, WorkoutFixtures.myPlan)
    }
    
    func testSavePlan_CacheError() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = emptyRoutines
        cacheInteractor.loadThrow = true
        
        XCTAssertThrowsError(try sut.savePlan(WorkoutFixtures.myPlan))
        XCTAssertFalse(cacheInteractor.saveCalled)
    }
    
    func testSavePlan_Success() throws {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = emptyRoutines
        
        try sut.savePlan(WorkoutFixtures.myPlan)
        
        let savedData = cacheInteractor.stubData as? CreatedRoutines
        let expectedPlans: [String: Plan] = [
            WorkoutFixtures.myPlanId: WorkoutFixtures.myPlan
        ]
        
        XCTAssertEqual(savedData?.plans, expectedPlans)
        XCTAssertTrue(cacheInteractor.saveCalled)
    }
}

// MARK: - Private

private extension CreatedRoutinesServiceTests {
    func setupRoutines() {
        cacheInteractor.stubFileExists = true
        cacheInteractor.stubData = WorkoutFixtures.loadedRoutines
    }
}
