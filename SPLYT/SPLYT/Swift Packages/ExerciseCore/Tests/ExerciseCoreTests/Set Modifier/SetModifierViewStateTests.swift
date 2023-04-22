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
}
