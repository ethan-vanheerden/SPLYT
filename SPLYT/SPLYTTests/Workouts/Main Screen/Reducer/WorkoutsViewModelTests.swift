//
//  WorkoutsViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import XCTest
@testable import SPLYT

final class WorkoutsViewModelTests: XCTestCase {
    private var sut: HomeViewModel!
    private var mockInteractor: MockWorkoutsInteractor!
    private let fixtures = WorkoutsFixtures.self
    
    override func setUp() async throws {
        mockInteractor = MockWorkoutsInteractor()
        sut = HomeViewModel(interactor: mockInteractor)
    }
    
    func testLoadingOnStart() {
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func testSend_Load() async {
        await sut.send(.load)
        XCTAssertEqual(sut.viewState, .main(fixtures.mainDisplay))
    }
}
