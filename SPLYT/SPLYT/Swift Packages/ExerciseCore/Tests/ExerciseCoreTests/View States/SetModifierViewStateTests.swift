//
//  SetModifierViewStateTests.swift
//
//
//  Created by Ethan Van Heerden on 4/20/23.
//

import XCTest
import ExerciseCore

final class SetModifierViewStateTests: XCTestCase {
    
    func testAllCases() {
        let result = SetModifierViewState.allCases
        
        let expected: [SetModifierViewState] = [
            .dropSet(set: .repsWeight(weightTitle: "lbs", repsTitle: "reps")),
            .restPause(set: .repsOnly(title: "reps")),
            .eccentric
        ]
        
        XCTAssertEqual(result, expected)
    }
    
    func testTitle() {
        let dropSet: SetModifierViewState = .dropSet(set: .repsWeight(weightTitle: "lbs",
                                                                      repsTitle: "reps"))
        let restPause: SetModifierViewState = .restPause(set: .repsOnly(title: "reps"))
        let eccentric: SetModifierViewState = .eccentric
        
        XCTAssertEqual(dropSet.title, "Drop Set")
        XCTAssertEqual(restPause.title, "Rest/Pause")
        XCTAssertEqual(eccentric.title, "Eccentric")
    }
    
    func testHasValue_DropSet() {
        let value: SetModifierViewState = .dropSet(set: .repsWeight(weightTitle: "lbs",
                                                                    repsTitle: "reps",
                                                                    input: .init(weight: 20, reps: 10)))
        let noValue: SetModifierViewState = .dropSet(set: .repsWeight(weightTitle: "lbs",
                                                                      repsTitle: "reps",
                                                                      input: .init(repsPlaceholder: 10)))
        
        XCTAssertTrue(value.hasValue)
        XCTAssertFalse(noValue.hasValue)
    }
    
    func testHasValue_RestPause() {
        let value: SetModifierViewState = .restPause(set: .repsOnly(title: "reps",
                                                                    input: .init(reps: 10, placeholder: 5)))
        let noValue: SetModifierViewState = .restPause(set: .repsOnly(title: "reps"))
        
        XCTAssertTrue(value.hasValue)
        XCTAssertFalse(noValue.hasValue)
    }
    
    func testHasValue_Eccentric() {
        XCTAssertFalse(SetModifierViewState.eccentric.hasValue)
    }
    
    func testHasPlaceholder_DropSet() {
        let placeholder: SetModifierViewState = .dropSet(set: .repsWeight(weightTitle: "lbs",
                                                                          repsTitle: "reps",
                                                                          input: .init(repsPlaceholder: 10)))
        let noPlaceholder: SetModifierViewState = .dropSet(set: .repsWeight(weightTitle: "lbs",
                                                                            repsTitle: "reps",
                                                                            input: .init(weight: 20, reps: 10)))
        
        
        XCTAssertTrue(placeholder.hasPlaceholder)
        XCTAssertFalse(noPlaceholder.hasPlaceholder)
    }
    
    func testHasPlaceholder_RestPause() {
        let placeholder: SetModifierViewState = .restPause(set: .repsOnly(title: "reps",
                                                                          input: .init(reps: 10, placeholder: 5)))
        let noPlaceholder: SetModifierViewState = .restPause(set: .repsOnly(title: "reps"))
        
        XCTAssertTrue(placeholder.hasPlaceholder)
        XCTAssertFalse(noPlaceholder.hasPlaceholder)
    }
    
    func testHasPlaceholder_Eccentric() {
        XCTAssertFalse(SetModifierViewState.eccentric.hasPlaceholder)
    }
    
    func testHasAdditionalInput() {
        let dropSet: SetModifierViewState = .dropSet(set: .repsWeight(weightTitle: "lbs",
                                                                      repsTitle: "reps"))
        let restPause: SetModifierViewState = .restPause(set: .repsOnly(title: "reps"))
        let eccentric: SetModifierViewState = .eccentric
        
        XCTAssertTrue(dropSet.hasAdditionalInput)
        XCTAssertTrue(restPause.hasAdditionalInput)
        XCTAssertFalse(eccentric.hasAdditionalInput)
    }
}
