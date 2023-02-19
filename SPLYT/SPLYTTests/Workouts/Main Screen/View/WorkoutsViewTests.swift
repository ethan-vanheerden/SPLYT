//
//  WorkoutsViewTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/20/22.
//

import XCTest
@testable import SPLYT
import SnapshotTesting
import SwiftUI

// TODO: run when Xcode is fixed
final class WorkoutsViewTests: XCTestCase {
    private var viewModel: MockWorkoutsViewModel!
    private var sut: WorkoutsView<MockWorkoutsViewModel>!
    private var vc: UIHostingController<WorkoutsView<MockWorkoutsViewModel>>!
    private let fixtures = WorkoutsFixtures.self
    
    override func setUp() {
        viewModel = MockWorkoutsViewModel()
        sut = WorkoutsView(viewModel: viewModel,
                           navigationRouter: WorkoutsNavigationRouter())
        vc = UIHostingController(rootView: sut)
    }
    
    func testLoading() {
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
    
    func testWorkoutsView() {
        viewModel.viewState = .main(fixtures.mainDisplay)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
}