//
//  BuildPlanNavigationRouterTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/15/23.
//

import XCTest
@testable import SPLYT
import Mocking
@testable import ExerciseCore
import SwiftUI

final class BuildPlanNavigationRouterTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockNavigator: MockNavigator!
    private var sut: BuildPlanNavigationRouter!

    override func setUpWithError() throws {
        let interactor = BuildPlanInteractor(service: MockBuildPlanService(),
                                         nameState: .init(name: WorkoutFixtures.myPlanName),
                                         creationDate: WorkoutFixtures.jan_1_2023_0800)
        let viewModel = BuildPlanViewModel(interactor: interactor)
        mockNavigator = MockNavigator()
        sut = BuildPlanNavigationRouter(viewModel: viewModel)
        sut.navigator = mockNavigator
    }
    
    func testNavigate_Back() {
        sut.navigate(.back)
        XCTAssertTrue(mockNavigator.calledPop)
    }
    
    func testNavigate_Exit() {
        sut.navigate(.exit)
        XCTAssertTrue(mockNavigator.calledDismissSelf)
    }
    
    func testNavigate_CreateNewWorkout() {
        sut.navigate(.createNewWorkout)
        
        let expectedNavController = UINavigationController.self
        let expectedVC = UIHostingController<NameWorkoutView<NameWorkoutViewModel>>.self
        
        XCTAssertTrue(mockNavigator.stubPresentedVC?.isKind(of: expectedNavController) ?? false)
        let navController = mockNavigator.stubPresentedVC as? UINavigationController
        XCTAssertTrue(navController?.topViewController?.isKind(of: expectedVC) ?? false)
    }
}
