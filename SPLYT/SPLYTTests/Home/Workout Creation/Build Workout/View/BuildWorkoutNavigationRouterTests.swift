//
//  BuildWorkoutNavigationRouterTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 3/6/23.
//

import XCTest
@testable import SPLYT
import Mocking
import SwiftUI

final class BuildWorkoutNavigationRouterTests: XCTestCase {
    typealias Fixtures = BuildWorkoutFixtures
    private var mockNavigator: MockNavigator!
    private var sut: BuildWorkoutNavigationRouter!
    
    override func setUpWithError() throws {
        let nameState = NameWorkoutNavigationState(name: Fixtures.workoutName)
        let interactor = BuildWorkoutInteractor(service: MockBuildWorkoutService(),
                                                nameState: nameState)
        let viewModel = BuildWorkoutViewModel(interactor: interactor)
        sut = BuildWorkoutNavigationRouter(viewModel: viewModel)
        mockNavigator = MockNavigator()
        sut.navigator = mockNavigator
    }

    func testNavigate_Exit() {
        sut.navigate(.exit)
        XCTAssertTrue(mockNavigator.calledDismissSelf)
    }
    
    func testNavigate_EditSetsReps() {
        sut.navigate(.editSetsReps)
        
        let expectedVC = UIHostingController<EditSetsRepsView<BuildWorkoutViewModel>>.self
        XCTAssertTrue(mockNavigator.stubPushedVC?.isKind(of: expectedVC) ?? false)
    }
    
    func testNavigate_GoBack() {
        sut.navigate(.goBack)
        XCTAssertTrue(mockNavigator.calledPop)
    }
}
