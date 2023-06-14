//
//  SetInputViewStateTests.swift
//  
//
//  Created by Ethan Van Heerden on 5/18/23.
//

import XCTest
@testable import ExerciseCore

final class SetInputViewStateTests: XCTestCase {
    var sut: SetInputViewState!
    
    func testHasInput_RepsWeight() {
        let inputValueReps = RepsWeightInput(reps: 5, repsPlaceholder: 10)
        let inputValueWeight = RepsWeightInput(weight: 8, repsPlaceholder: 5)
        
        sut = .repsWeight(weightTitle: "lbs", repsTitle: "reps", input: inputValueReps)
        XCTAssertTrue(sut.hasInput)
        
        sut = .repsWeight(weightTitle: "lbs", repsTitle: "reps", input: inputValueWeight)
        XCTAssertTrue(sut.hasInput)
        
        sut = .repsWeight(weightTitle: "lbs", repsTitle: "reps")
        XCTAssertFalse(sut.hasInput)
    }
    
    func testHasInput_RepsOnly() {
        let inputValue = RepsOnlyInput(reps: 10)
        
        sut = .repsOnly(title: "reps", input: inputValue)
        XCTAssertTrue(sut.hasInput)
        
        sut = .repsOnly(title: "reps")
        XCTAssertFalse(sut.hasInput)
    }
    
    func testHasInput_Time() {
        let inputValue = TimeInput(seconds: 10)
        
        sut = .time(title: "sec", input: inputValue)
        XCTAssertTrue(sut.hasInput)
        
        sut = .time(title: "sec")
        XCTAssertFalse(sut.hasInput)
    }
    
    func testHasPlaceholder_RepsWeight() {
        let inputPlaceholderReps = RepsWeightInput(reps: 5, repsPlaceholder: 10)
        let inputPlaceholderWeight = RepsWeightInput(weightPlaceholder: 135)
        
        sut = .repsWeight(weightTitle: "lbs", repsTitle: "reps", input: inputPlaceholderReps)
        XCTAssertTrue(sut.hasPlaceholder)
        
        sut = .repsWeight(weightTitle: "lbs", repsTitle: "reps", input: inputPlaceholderWeight)
        XCTAssertTrue(sut.hasPlaceholder)
        
        sut = .repsWeight(weightTitle: "lbs", repsTitle: "reps")
        XCTAssertFalse(sut.hasPlaceholder)
    }
    
    func testHasPlaceholder_RepsOnly() {
        let inputPlaceholder = RepsOnlyInput(reps: 5, placeholder: 5)
        
        sut = .repsOnly(title: "reps", input: inputPlaceholder)
        XCTAssertTrue(sut.hasPlaceholder)
        
        sut = .repsOnly(title: "reps")
        XCTAssertFalse(sut.hasPlaceholder)
    }
    
    func testHasPlaceholder_Time() {
        let inputPlaceholder = TimeInput(placeholder: 5)
        
        sut = .time(title: "sec", input: inputPlaceholder)
        XCTAssertTrue(sut.hasPlaceholder)
        
        sut = .time(title: "sec")
        XCTAssertFalse(sut.hasPlaceholder)
    }
}
