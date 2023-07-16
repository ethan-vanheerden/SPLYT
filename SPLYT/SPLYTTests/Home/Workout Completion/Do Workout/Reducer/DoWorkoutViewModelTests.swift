//
//  DoWorkoutViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 6/12/23.
//

import XCTest
@testable import SPLYT
@testable import DesignSystem
@testable import ExerciseCore

final class DoWorkoutViewModelTests: XCTestCase {
    typealias Fixtures = DoWorkoutFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    typealias StateFixtures = WorkoutViewStateFixtures
    private var interactor: DoWorkoutInteractor!
    private var sut: DoWorkoutViewModel!
    
    override func setUpWithError() throws {
        self.interactor = DoWorkoutInteractor(workoutId: WorkoutFixtures.legWorkoutId,
                                              historyFilename: WorkoutFixtures.legWorkoutFilename,
                                              service: MockDoWorkoutService())
        self.sut = DoWorkoutViewModel(interactor: interactor)
    }
    
    func testLoadingOnInit() {
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func testSend_LoadWorkout() async {
        await sut.send(.loadWorkout)
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: Fixtures.legWorkoutStartingGroups,
                                       expandedGroups: [true, false],
                                       inCountdown: true,
                                       isResting: false,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(display))
    }
    
    func testSend_StopCountdown() async {
        await sut.send(.loadWorkout)
        await sut.send(.stopCountdown)
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: Fixtures.legWorkoutStartingGroups,
                                       expandedGroups: [true, false],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(display))
    }
    
    func testSend_ToggleRest() async {
        await load()
        await sut.send(.toggleRest(isResting: true))
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: Fixtures.legWorkoutStartingGroups,
                                       expandedGroups: [true, false],
                                       inCountdown: false,
                                       isResting: true,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(display))
    }
    
    func testSend_ToggleGroupExpand() async {
        await load()
        await sut.send(.toggleGroupExpand(group: 0, isExpanded: false))
        await sut.send(.toggleGroupExpand(group: 1, isExpanded: true))
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: Fixtures.legWorkoutStartingGroups,
                                       expandedGroups: [false, true],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(display))
    }
    
    func testSend_CompleteGroup() async {
        await load()
        await sut.send(.completeGroup(group: 0))
        
        var groups = Fixtures.legWorkoutStartingGroups
        groups[0] = DoExerciseGroupViewState(header: Fixtures.groupOneHeader(isComplete: true),
                                             exercises: groups[0].exercises,
                                             slider: nil)
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0.5),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: groups,
                                       expandedGroups: [false, true],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(display))
    }
    
    func testSend_AddSet() async {
        await load()
        await sut.send(.addSet(group: 0))
        
        var sets = StateFixtures.repsWeight4SetsPlaceholders
        let newSet = sets.last!
        sets.append(newSet)
        
        let backSquat = StateFixtures.backSquatViewState(inputs: sets, includeHeaderLine: false)
        var groups = Fixtures.legWorkoutStartingGroups
        groups[0] = DoExerciseGroupViewState(header: Fixtures.groupOneHeader(isComplete: false),
                                             exercises: [backSquat],
                                             slider: Fixtures.actionSlider)
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0.0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: groups,
                                       expandedGroups: [true, false],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(display))
    }
    
    func testSend_RemoveSet() async {
        await load()
        await sut.send(.removeSet(group: 0))
        
        var sets = StateFixtures.repsWeight4SetsPlaceholders
        sets.removeLast()
        
        let backSquat = StateFixtures.backSquatViewState(inputs: sets, includeHeaderLine: false)
        var groups = Fixtures.legWorkoutStartingGroups
        groups[0] = DoExerciseGroupViewState(header: Fixtures.groupOneHeader(isComplete: false),
                                             exercises: [backSquat],
                                             slider: Fixtures.actionSlider)
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0.0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: groups,
                                       expandedGroups: [true, false],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(display))
    }
    
    func testSend_UpdateSet_NormalInput() async {
        await load()
        let updatedInput: RepsWeightInput = .init(weight: 315, reps: 1)
        await sut.send(.updateSet(group: 0,
                                  exerciseIndex: 0,
                                  setIndex: 0,
                                  with: .repsWeight(input: updatedInput),
                                  forModifier: false))
        
        var sets = StateFixtures.repsWeight4SetsPlaceholders
        sets[0].0 = .repsWeight(weightTitle: StateFixtures.lbs,
                                repsTitle: StateFixtures.reps,
                                input: updatedInput)
        
        let backSquat = StateFixtures.backSquatViewState(inputs: sets, includeHeaderLine: false)
        var groups = Fixtures.legWorkoutStartingGroups
        groups[0] = DoExerciseGroupViewState(header: Fixtures.groupOneHeader(isComplete: false),
                                             exercises: [backSquat],
                                             slider: Fixtures.actionSlider)
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0.0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: groups,
                                       expandedGroups: [true, false],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(display))
    }
    
    func testSend_UpdateSet_ModifierInput() async {
        await load()
        await sut.send(.toggleGroupExpand(group: 1, isExpanded: true))
        let updatedInput: RepsWeightInput = .init(weight: 100, reps: 4)
        await sut.send(.updateSet(group: 1,
                                  exerciseIndex: 0,
                                  setIndex: 2,
                                  with: .repsWeight(input: updatedInput),
                                  forModifier: true))
        
        var sets = StateFixtures.repsWeight3SetsPlaceholders
        sets[2].1 = .dropSet(set: .repsWeight(weightTitle: StateFixtures.lbs,
                                              repsTitle: StateFixtures.reps,
                                              input: updatedInput))
        
        let barLunges = StateFixtures.barLungesViewState(inputs: sets, includeHeaderLine: false)
        var groups = Fixtures.legWorkoutStartingGroups
        groups[1] = DoExerciseGroupViewState(header: Fixtures.groupTwoHeader(isComplete: false),
                                             exercises: [barLunges],
                                             slider: Fixtures.actionSlider)
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0.0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: groups,
                                       expandedGroups: [true, true],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(display))
    }
    
    func testSend_UsePreviousInput_NormalInput() async {
        await load()
        await sut.send(.usePreviousInput(group: 0,
                                         exerciseIndex: 0,
                                         setIndex: 0,
                                         forModifier: false))
        
        let updatedInput: RepsWeightInput = .init(weight: 135,
                                                  weightPlaceholder: 135,
                                                  reps: 12,
                                                  repsPlaceholder: 12)
        var sets = StateFixtures.repsWeight4SetsPlaceholders
        sets[0].0 = .repsWeight(weightTitle: StateFixtures.lbs,
                                repsTitle: StateFixtures.reps,
                                input: updatedInput)
        
        let backSquat = StateFixtures.backSquatViewState(inputs: sets, includeHeaderLine: false)
        var groups = Fixtures.legWorkoutStartingGroups
        groups[0] = DoExerciseGroupViewState(header: Fixtures.groupOneHeader(isComplete: false),
                                             exercises: [backSquat],
                                             slider: Fixtures.actionSlider)
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0.0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: groups,
                                       expandedGroups: [true, false],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(display))
    }
    
    func testSend_UsePreviousInput_ModifierInput() async {
        await load()
        await sut.send(.toggleGroupExpand(group: 1, isExpanded: true))
        await sut.send(.usePreviousInput(group: 1,
                                         exerciseIndex: 0,
                                         setIndex: 2,
                                         forModifier: true))
        
        let updatedInput: RepsWeightInput = .init(weight: 100,
                                                  weightPlaceholder: 100,
                                                  reps: 5,
                                                  repsPlaceholder: 5)
        
        var sets = StateFixtures.repsWeight3SetsPlaceholders
        sets[2].1 = .dropSet(set: .repsWeight(weightTitle: StateFixtures.lbs,
                                              repsTitle: StateFixtures.reps,
                                              input: updatedInput))
        
        let barLunges = StateFixtures.barLungesViewState(inputs: sets, includeHeaderLine: false)
        var groups = Fixtures.legWorkoutStartingGroups
        groups[1] = DoExerciseGroupViewState(header: Fixtures.groupTwoHeader(isComplete: false),
                                             exercises: [barLunges],
                                             slider: Fixtures.actionSlider)
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0.0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: groups,
                                       expandedGroups: [true, true],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(display))
    }
    
    func testSend_ToggleDialog_FinishDialog_Open() async {
        await load()
        await sut.send(.toggleDialog(dialog: .finishWorkout, isOpen: true))
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: Fixtures.legWorkoutStartingGroups,
                                       expandedGroups: [true, false],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: .finishWorkout,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(display))
    }
    
    func testSend_ToggleDialog_FinishDialog_Close() async {
        await load()
        await sut.send(.toggleDialog(dialog: .finishWorkout, isOpen: true)) // Open so we can close it
        await sut.send(.toggleDialog(dialog: .finishWorkout, isOpen: false))
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: Fixtures.legWorkoutStartingGroups,
                                       expandedGroups: [true, false],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(sut.viewState, .loaded(display))
    }
    
    func testSend_SaveWorkout() async {
        await load()
        await sut.send(.saveWorkout)
        
        let display = DoWorkoutDisplay(workoutName: WorkoutFixtures.legWorkoutName,
                                       progressBar: Fixtures.progressBar(fractionCompleted: 0),
                                       groupTitles: ["Group 1", "Group 2"],
                                       groups: Fixtures.legWorkoutStartingGroups,
                                       expandedGroups: [true, false],
                                       inCountdown: false,
                                       isResting: false,
                                       presentedDialog: nil,
                                       finishDialog: Fixtures.finishDialog)
        
        XCTAssertEqual(sut.viewState, .exit(display))
    }
}

// MARK: - Private

private extension DoWorkoutViewModelTests {
    func load() async {
        await sut.send(.loadWorkout)
        await sut.send(.stopCountdown)
    }
}
