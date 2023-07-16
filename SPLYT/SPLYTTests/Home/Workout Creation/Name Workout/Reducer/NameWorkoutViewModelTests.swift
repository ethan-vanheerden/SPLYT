//
//  NameWorkoutViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 1/10/23.
//

import XCTest
@testable import SPLYT

final class NameWorkoutViewModelTests: XCTestCase {
    typealias Fixtures = NameWorkoutFixtures
    
    func testLoadingOnInit() {
        for buildType in BuildWorkoutType.allCases {
            let interactor = NameWorkoutInteractor(buildType: buildType)
            let sut = NameWorkoutViewModel(interactor: interactor)
            
            XCTAssertEqual(sut.viewState, .loading)
        }
    }
    
    func testSend_Load_Workout() async {
        let interactor = NameWorkoutInteractor(buildType: .workout)
        let sut = NameWorkoutViewModel(interactor: interactor)
        await sut.send(.load)
        
        let expectedDisplay = NameWorkoutDisplay(navBar: Fixtures.workoutNavBar,
                                                 workoutName: "",
                                                 textEntry: Fixtures.workoutTextEntry,
                                                 buildType: .workout,
                                                 nextButtonEnabled: false)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_Load_Plan() async {
        let interactor = NameWorkoutInteractor(buildType: .plan)
        let sut = NameWorkoutViewModel(interactor: interactor)
        await sut.send(.load)
        
        let expectedDisplay = NameWorkoutDisplay(navBar: Fixtures.planNavBar,
                                                 workoutName: "",
                                                 textEntry: Fixtures.planTextEntry,
                                                 buildType: .plan,
                                                 nextButtonEnabled: false)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_NoSavedDomain_Error() async {
        let interactor = NameWorkoutInteractor(buildType: .workout)
        let sut = NameWorkoutViewModel(interactor: interactor)
        await sut.send(.updateWorkoutName(name: "Legs"))
        
        XCTAssertEqual(sut.viewState, .error)
    }
    
    func testSend_UpdateWorkoutName_Workout() async {
        let interactor = NameWorkoutInteractor(buildType: .workout)
        let sut = NameWorkoutViewModel(interactor: interactor)
        await sut.send(.load)
        await sut.send(.updateWorkoutName(name: "Legs"))
        
        let expectedDisplay = NameWorkoutDisplay(navBar: Fixtures.workoutNavBar,
                                                 workoutName: "Legs",
                                                 textEntry: Fixtures.workoutTextEntry,
                                                 buildType: .workout,
                                                 nextButtonEnabled: true)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
    
    func testSend_UpdatePlanName_Plan() async {
        let interactor = NameWorkoutInteractor(buildType: .plan)
        let sut = NameWorkoutViewModel(interactor: interactor)
        await sut.send(.load)
        await sut.send(.updateWorkoutName(name: "Legs"))
        
        let expectedDisplay = NameWorkoutDisplay(navBar: Fixtures.planNavBar,
                                                 workoutName: "Legs",
                                                 textEntry: Fixtures.planTextEntry,
                                                 buildType: .plan,
                                                 nextButtonEnabled: true)
        
        XCTAssertEqual(sut.viewState, .loaded(expectedDisplay))
    }
}
