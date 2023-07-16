//
//  NameWorkoutInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import XCTest
@testable import SPLYT

final class NameWorkoutInteractorTests: XCTestCase {
    
    func testInteract_Load() async {
        for buildType in BuildWorkoutType.allCases {
            let sut = NameWorkoutInteractor(buildType: buildType)
            let result = await sut.interact(with: .load)
            
            let expectedDomain = NameWorkoutDomain(workoutName: "",
                                                   buildType: buildType)
            
            XCTAssertEqual(result, .loaded(expectedDomain))
        }
    }
    
    func testInteract_UpdateWorkoutName_NoSavedDomain_Error() async {
        let sut = NameWorkoutInteractor(buildType: .workout)
        let result = await sut.interact(with: .updateWorkoutName(name: "Legs"))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_UpdateWorkoutName_Success() async {
        for buildType in BuildWorkoutType.allCases {
            let sut = NameWorkoutInteractor(buildType: buildType)
            _ = await sut.interact(with: .load)
            let result = await sut.interact(with: .updateWorkoutName(name: "Legs"))
            
            let expectedDomain = NameWorkoutDomain(workoutName: "Legs",
                                                   buildType: buildType)
            
            XCTAssertEqual(result, .loaded(expectedDomain))
        }
    }
}
