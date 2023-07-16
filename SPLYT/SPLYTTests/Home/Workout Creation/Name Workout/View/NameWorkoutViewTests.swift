//
//  NameWorkoutsViewTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/20/22.
//

import XCTest
@testable import SPLYT
import SnapshotTesting
import SwiftUI
import Core
import DesignSystem

final class NameWorkoutsViewTests: XCTestCase {
    private var viewModel: MockNameWorkoutViewModel!
    private var sut: NameWorkoutView<MockNameWorkoutViewModel>!
    private var vc: UIHostingController<NameWorkoutView<MockNameWorkoutViewModel>>!
    
    override func setUp() {
        viewModel = MockNameWorkoutViewModel()
        sut = NameWorkoutView(viewModel: viewModel,
                              navigationRouter: NameWorkoutNavigationRouter(),
                              dismissAction: { })
        vc = UIHostingController(rootView: sut)
    }
    
    func testLoading() {
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
}

// MARK: - Mock View Model

final class MockNameWorkoutViewModel: ViewModel {
    @Published var viewState: NameWorkoutViewState = .loading
    func send(_ event: NameWorkoutViewEvent) async { }
}
