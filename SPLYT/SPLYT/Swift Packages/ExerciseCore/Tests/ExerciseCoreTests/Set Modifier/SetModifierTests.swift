//
//  SetModifierTests.swift
//
//
//  Created by Ethan Van Heerden on 4/22/23.
//

import XCTest
import ExerciseCore

final class SetModifierTests: XCTestCase {
    private let repsWeight: SetInput = .repsWeight(reps: 10, weight: 100)
    private let repsOnly: SetInput = .repsOnly(reps: 10)
    private let time: SetInput = .time(seconds: 30)
    
    func testUpdateModifierInput_DropSet() {
        let old: SetModifier = .dropSet(input: .repsWeight(reps: nil, weight: 100))
        
        XCTAssertEqual(old.updateModifierInput(with: repsWeight), .dropSet(input: repsWeight))
        XCTAssertEqual(old.updateModifierInput(with: repsOnly), old)
        XCTAssertEqual(old.updateModifierInput(with: time), old)
    }
    
    func testUpdateModifierInput_RestPause() {
        let old: SetModifier = .restPause(input: .repsOnly(reps: nil))
        
        XCTAssertEqual(old.updateModifierInput(with: repsWeight), old)
        XCTAssertEqual(old.updateModifierInput(with: repsOnly), .restPause(input: repsOnly))
        XCTAssertEqual(old.updateModifierInput(with: time), old)
    }
    
    func testUpdateModifierInput_Eccentric() {
        let old: SetModifier = .eccentric
        
        XCTAssertEqual(old.updateModifierInput(with: repsWeight), old)
        XCTAssertEqual(old.updateModifierInput(with: repsOnly), old)
        XCTAssertEqual(old.updateModifierInput(with: time), old)
    }
}
