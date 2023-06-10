//
//  WorkoutReducerTests.swift
//  
//
//  Created by Ethan Van Heerden on 6/10/23.
//

import XCTest
@testable import DesignSystem
@testable import ExerciseCore

final class WorkoutReducerTests: XCTestCase {
    typealias Fixtures = WorkoutViewStateFixtures
    typealias ModelFixtures = WorkoutModelFixtures
    private let sut = WorkoutReducer.self
    
    func testReduceExerciseGroups_HeaderLine() {
        [true, false].forEach {
            let result = sut.reduceExerciseGroups(groups: ModelFixtures.legWorkoutExercises,
                                                  includeHeaderLine: $0)
            XCTAssertEqual(result, Fixtures.legWorkoutExercises(includeHeaderLine: $0))
        }
    }
}
