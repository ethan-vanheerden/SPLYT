//
//  NameWorkoutInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import XCTest
@testable import SPLYT
import ExerciseCore

final class NameWorkoutInteractorTests: XCTestCase {
    
    func testInteract_Load() async {
        for routineType in RoutineType.allCases {
            let sut = NameWorkoutInteractor(routineType: routineType)
            let result = await sut.interact(with: .load)
            
            let expectedDomain = NameWorkoutDomain(workoutName: "",
                                                   routineType: routineType)
            
            XCTAssertEqual(result, .loaded(expectedDomain))
        }
    }
    
    func testInteract_UpdateWorkoutName_NoSavedDomain_Error() async {
        let sut = NameWorkoutInteractor(routineType: .workout)
        let result = await sut.interact(with: .updateWorkoutName(name: "Legs"))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_UpdateWorkoutName_Success() async {
        for routineType in RoutineType.allCases {
            let sut = NameWorkoutInteractor(routineType: routineType)
            _ = await sut.interact(with: .load)
            let result = await sut.interact(with: .updateWorkoutName(name: "Legs"))
            
            let expectedDomain = NameWorkoutDomain(workoutName: "Legs",
                                                   routineType: routineType)
            
            XCTAssertEqual(result, .loaded(expectedDomain))
        }
    }
}
