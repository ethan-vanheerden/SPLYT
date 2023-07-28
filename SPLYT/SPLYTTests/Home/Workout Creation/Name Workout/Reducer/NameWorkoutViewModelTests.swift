//
//  NameWorkoutViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 1/10/23.
//

import XCTest
@testable import SPLYT
import ExerciseCore

final class NameWorkoutViewModelTests: XCTestCase {
    typealias Fixtures = NameWorkoutFixtures
    
    func testLoadingOnInit() {
        for routineType in RoutineType.allCases {
            let interactor = NameWorkoutInteractor(routineType: routineType)
            let sut = NameWorkoutViewModel(interactor: interactor)
            
            XCTAssertEqual(sut.viewState, .loading)
        }
    }
    
    func testSend_Load_Workout() async {
        let interactor = NameWorkoutInteractor(routineType: .workout)
        let sut = NameWorkoutViewModel(interactor: interactor)
        await sut.send(.load)
        
        let expectedDisplay = NameWorkoutDisplay(navBar: Fixtures.workoutNavBar,
                                                 workoutName: "",
                                                 textEntry: Fixtures.workoutTextEntry,
                                                 routineType: .workout,
                                                 nextButtonEnabled: false)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_Load_Plan() async {
        let interactor = NameWorkoutInteractor(routineType: .plan)
        let sut = NameWorkoutViewModel(interactor: interactor)
        await sut.send(.load)
        
        let expectedDisplay = NameWorkoutDisplay(navBar: Fixtures.planNavBar,
                                                 workoutName: "",
                                                 textEntry: Fixtures.planTextEntry,
                                                 routineType: .plan,
                                                 nextButtonEnabled: false)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_NoSavedDomain_Error() async {
        let interactor = NameWorkoutInteractor(routineType: .workout)
        let sut = NameWorkoutViewModel(interactor: interactor)
        await sut.send(.updateWorkoutName(name: "Legs"))
        
        XCTAssertEqual(sut.viewState, .error)
    }
    
    func testSend_UpdateWorkoutName_Workout() async {
        let interactor = NameWorkoutInteractor(routineType: .workout)
        let sut = NameWorkoutViewModel(interactor: interactor)
        await sut.send(.load)
        await sut.send(.updateWorkoutName(name: "Legs"))
        
        let expectedDisplay = NameWorkoutDisplay(navBar: Fixtures.workoutNavBar,
                                                 workoutName: "Legs",
                                                 textEntry: Fixtures.workoutTextEntry,
                                                 routineType: .workout,
                                                 nextButtonEnabled: true)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_UpdatePlanName_Plan() async {
        let interactor = NameWorkoutInteractor(routineType: .plan)
        let sut = NameWorkoutViewModel(interactor: interactor)
        await sut.send(.load)
        await sut.send(.updateWorkoutName(name: "Legs"))
        
        let expectedDisplay = NameWorkoutDisplay(navBar: Fixtures.planNavBar,
                                                 workoutName: "Legs",
                                                 textEntry: Fixtures.planTextEntry,
                                                 routineType: .plan,
                                                 nextButtonEnabled: true)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
}
