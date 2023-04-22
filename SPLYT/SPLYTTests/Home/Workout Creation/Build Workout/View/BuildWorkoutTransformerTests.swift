//
//  BuildWorkoutTransformerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 4/20/23.
//

import XCTest
@testable import SPLYT
import ExerciseCore
import DesignSystem

final class BuildWorkoutTransformerTests: XCTestCase {
    private let sut = BuildWorkoutTransformer()
    
    func testTransformModifier_DropSet_RepsWeight() {
        let setInputViewState: SetInputViewState = .repsWeight(weightTitle: "lbs",
                                                        weight: 100,
                                                        repsTitle: "reps",
                                                        reps: 8)
        let modifierViewState: SetModifierViewState = .dropSet(set: setInputViewState)
        
        let result = sut.transformModifier(modifierViewState)
        
        let expectedSetInput: SetInput = .repsWeight(reps: 8, weight: 100)
        let expectedModifier: SetModifier = .dropSet(input: expectedSetInput)
        
        XCTAssertEqual(result, expectedModifier)
    }
    
    func testTransformModifier_DropSet_RepsOnly() {
        let setInputViewState: SetInputViewState = .repsOnly(title: "reps")
        let modifierViewState: SetModifierViewState = .dropSet(set: setInputViewState)
        
        let result = sut.transformModifier(modifierViewState)
        
        let expectedSetInput: SetInput = .repsOnly(reps: nil)
        let expectedModifier: SetModifier = .dropSet(input: expectedSetInput)
        
        XCTAssertEqual(result, expectedModifier)
    }
    
    func testTransformModifier_DropSet_Time() {
        let setInputViewState: SetInputViewState = .time(title: "sec", seconds: 10)
        let modifierViewState: SetModifierViewState = .dropSet(set: setInputViewState)
        
        let result = sut.transformModifier(modifierViewState)
        
        let expectedSetInput: SetInput = .time(seconds: 10)
        let expectedModifier: SetModifier = .dropSet(input: expectedSetInput)
        
        XCTAssertEqual(result, expectedModifier)
    }
    
    func testTransformModifier_RestPause() {
        let setInputViewState: SetInputViewState = .repsOnly(title: "reps", reps: 5)
        let modifierViewState: SetModifierViewState = .restPause(set: setInputViewState)
        
        let result = sut.transformModifier(modifierViewState)
        
        let expectedSetInput: SetInput = .repsOnly(reps: 5)
        let expectedModifier: SetModifier = .restPause(input: expectedSetInput)
        
        XCTAssertEqual(result, expectedModifier)
    }
    
    func testTransformModifier_Eccentric() {
        let modifierViewState: SetModifierViewState = .eccentric
        
        let result = sut.transformModifier(modifierViewState)
        
        let expectedModifier: SetModifier = .eccentric
        
        XCTAssertEqual(result, expectedModifier)
    }
}
