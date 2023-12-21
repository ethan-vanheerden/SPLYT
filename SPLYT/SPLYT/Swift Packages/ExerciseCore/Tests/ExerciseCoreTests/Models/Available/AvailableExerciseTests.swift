//
//  AvailableExerciseTests.swift
//
//
//  Created by Ethan Van Heerden on 12/19/23.
//

import XCTest
import ExerciseCore

final class AvailableExerciseTests: XCTestCase {
    func testFavoriteFieldDecoding() throws {
        let jsonDataWithFavorite = """
                {
                    "id": "test",
                    "name": "test",
                    "muscles_worked": [],
                    "default_input_type": {
                        "REPS_WEIGHT": {
                            "input": {}
                        }
                    },
                    "is_favorite": true
                }
                """.data(using: .utf8)!
        
        let jsonDataWithoutFavorite = """
                {
                    "id": "test",
                    "name": "test",
                    "muscles_worked": [],
                    "default_input_type": {
                        "REPS_WEIGHT": {
                            "input": {}
                        }
                    }
                }
                """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        let decodedWithFavorite = try decoder.decode(AvailableExercise.self, from: jsonDataWithFavorite)
        XCTAssertTrue(decodedWithFavorite.isFavorite)
        
        let decodedWithoutFavorite = try decoder.decode(AvailableExercise.self, from: jsonDataWithoutFavorite)
        XCTAssertFalse(decodedWithoutFavorite.isFavorite)
    }
}
