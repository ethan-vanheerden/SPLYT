//
//  NameWorkoutReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import XCTest
@testable import SPLYT

final class NameWorkoutReducerTests: XCTestCase {
    typealias Fixtures = NameWorkoutFixtures
    private let sut = NameWorkoutReducer()
    
    func testReduce_Error() {
        let result = sut.reduce(.error)
        XCTAssertEqual(result, .error)
    }
    
    func testReduce_Loaded_EmptyWorkoutName_Workout() async {
        let interactor = NameWorkoutInteractor(buildType: .workout)
        let domain = await interactor.interact(with: .load)
        let result = sut.reduce(domain)
        
        let expectedDisplay = NameWorkoutDisplay(navBar: Fixtures.workoutNavBar,
                                                 workoutName: "",
                                                 textEntry: Fixtures.workoutTextEntry,
                                                 buildType: .workout,
                                                 nextButtonEnabled: false)
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
    
    func testReduce_Loaded_EmptyWorkoutName_Plan() async {
        let interactor = NameWorkoutInteractor(buildType: .plan)
        let domain = await interactor.interact(with: .load)
        let result = sut.reduce(domain)
        
        let expectedDisplay = NameWorkoutDisplay(navBar: Fixtures.planNavBar,
                                                 workoutName: "",
                                                 textEntry: Fixtures.planTextEntry,
                                                 buildType: .plan,
                                                 nextButtonEnabled: false)
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
    
    func testReduce_Loaded_NonEmptyWorkoutName_Workout() async {
        let interactor = NameWorkoutInteractor(buildType: .workout)
        _ = await interactor.interact(with: .load)
        let domain = await interactor.interact(with: .updateWorkoutName(name: "Legs"))
        let result = sut.reduce(domain)
        
        let expectedDisplay = NameWorkoutDisplay(navBar: Fixtures.workoutNavBar,
                                                 workoutName: "Legs",
                                                 textEntry: Fixtures.workoutTextEntry,
                                                 buildType: .workout,
                                                 nextButtonEnabled: true)
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
    
    func testReduce_Loaded_NonEmptyWorkoutName_Plan() async {
        let interactor = NameWorkoutInteractor(buildType: .plan)
        _ = await interactor.interact(with: .load)
        let domain = await interactor.interact(with: .updateWorkoutName(name: "Legs"))
        let result = sut.reduce(domain)
        
        let expectedDisplay = NameWorkoutDisplay(navBar: Fixtures.planNavBar,
                                                 workoutName: "Legs",
                                                 textEntry: Fixtures.planTextEntry,
                                                 buildType: .plan,
                                                 nextButtonEnabled: true)
        
        XCTAssertEqual(result, .loaded(expectedDisplay))
    }
}
