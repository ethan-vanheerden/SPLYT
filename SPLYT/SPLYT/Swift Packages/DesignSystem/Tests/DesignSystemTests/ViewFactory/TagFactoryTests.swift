//
//  TagFactoryTests.swift
//  
//
//  Created by Ethan Van Heerden on 4/22/23.
//

import XCTest
import DesignSystem
import ExerciseCore

final class TagFactoryTests: XCTestCase {
    private let sut = TagFactory.self
    
    func testTagFromModifier_DropSet() {
        let modifier: SetModifierViewState = .dropSet(set: .repsWeight(weightTitle: "lbs",
                                                                       weight: 100,
                                                                       repsTitle: "reps",
                                                                       reps: 5))
        let result = sut.tagFromModifier(modifier: modifier)
        
        let expected = TagViewState(title: "Drop Set", color: .green)
        
        XCTAssertEqual(result, expected)
    }
    
    func testTagFromModifier_RestPause() {
        let modifier: SetModifierViewState = .restPause(set: .repsOnly(title: "reps"))
        let result = sut.tagFromModifier(modifier: modifier)
        
        let expected = TagViewState(title: "Rest/Pause", color: .gray)
        
        XCTAssertEqual(result, expected)
    }
    
    func testTagFromModifier_Eccentric() {
        let modifier: SetModifierViewState = .eccentric
        let result = sut.tagFromModifier(modifier: modifier)
        
        let expected = TagViewState(title: "Eccentric", color: .red)
        
        XCTAssertEqual(result, expected)
    }
}
