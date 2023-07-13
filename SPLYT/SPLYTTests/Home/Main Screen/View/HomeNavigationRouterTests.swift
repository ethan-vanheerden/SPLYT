//
//  HomeNavigationRouterTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import XCTest
@testable import SPLYT
import Mocking
import SwiftUI

final class HomeNavigationRouterTests: XCTestCase {
    private var sut: HomeNavigationRouter!
    private var mockNavigator: MockNavigator!
    
    override func setUp() async throws {
        sut = HomeNavigationRouter()
        mockNavigator = MockNavigator()
        sut.navigator = mockNavigator
    }
    
    func testNavigate_Create() {
        
        let createTypes: [HomeNavigationEvent] = [.createPlan, .createWorkout]
        
        for createType in createTypes {
            sut.navigate(createType)
            let expectedNavController = UINavigationController.self
            let expectedVC = UIHostingController<NameWorkoutView<NameWorkoutViewModel>>.self
            
            XCTAssertTrue(mockNavigator.stubPresentedVC?.isKind(of: expectedNavController) ?? false)
            let navController = mockNavigator.stubPresentedVC as? UINavigationController
            XCTAssertTrue(navController?.topViewController?.isKind(of: expectedVC) ?? false)
        }
    }
    
    func testNavigate_SelectWorkout() {
        sut.navigate(.seletectWorkout(id: "my-awesome-workout", historyFilename: "filename"))
        let expectedNavController = UINavigationController.self
        let expectedVC = UIHostingController<WorkoutPreviewView<DoWorkoutViewModel>>.self

        XCTAssertTrue(mockNavigator.stubPresentedVC?.isKind(of: expectedNavController) ?? false)
        let navController = mockNavigator.stubPresentedVC as? UINavigationController
        XCTAssertTrue(navController?.topViewController?.isKind(of: expectedVC) ?? false)
    }
    
    func testNavigate_EditWorkout() {
        // TODO
    }
    
    func testNavigate_SelectPlan() {
        sut.navigate(.selectPlan(id: "my-awesome-plan"))
        let expectedNavController = UINavigationController.self
        let expectedVC = UIHostingController<DoPlanView<DoPlanViewModel>>.self

        XCTAssertTrue(mockNavigator.stubPresentedVC?.isKind(of: expectedNavController) ?? false)
        let navController = mockNavigator.stubPresentedVC as? UINavigationController
        XCTAssertTrue(navController?.topViewController?.isKind(of: expectedVC) ?? false)
    }
    
    func testNavigate_EditPlan() {
        // TODO
    }
}
