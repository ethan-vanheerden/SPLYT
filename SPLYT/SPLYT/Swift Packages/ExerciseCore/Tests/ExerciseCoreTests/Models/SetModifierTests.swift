//
//  SetModifierTests.swift
//
//
//  Created by Ethan Van Heerden on 4/22/23.
//

import XCTest
import ExerciseCore

final class SetModifierTests: XCTestCase {
    private let repsWeight: SetInput = .repsWeight(input: .init(weight: 100, reps: 10))
    private let repsOnly: SetInput = .repsOnly(input: .init(reps: 10))
    private let time: SetInput = .time(input: .init(seconds: 30))
    private var dropSet: SetModifier!
    private var restPause: SetModifier!
    private var eccentric: SetModifier!
    
    override func setUp() async throws {
        self.dropSet = .dropSet(input: repsWeight)
        self.restPause = .restPause(input: repsOnly)
        self.eccentric = .eccentric
    }
    
    func testUpdateModifierInput_DropSet() {
        let old: SetModifier = .dropSet(input: .repsWeight(input: .init(weight: 100, reps: nil)))
        
        XCTAssertEqual(old.updateModifierInput(with: repsWeight), .dropSet(input: repsWeight))
    }
    
    func testUpdateModifierInput_RestPause() {
        let old: SetModifier = .restPause(input: .repsOnly(input: .init(reps: nil)))
        
        XCTAssertEqual(old.updateModifierInput(with: repsOnly), .restPause(input: repsOnly))
    }
    
    func testUpdateModifierInput_Eccentric() {
        let old: SetModifier = .eccentric
        
        XCTAssertEqual(old.updateModifierInput(with: repsWeight), old)
        XCTAssertEqual(old.updateModifierInput(with: repsOnly), old)
        XCTAssertEqual(old.updateModifierInput(with: time), old)
    }
    
    func testInput() {
        XCTAssertEqual(dropSet.input, repsWeight)
        XCTAssertEqual(restPause.input, repsOnly)
        XCTAssertNil(eccentric.input)
    }
}
