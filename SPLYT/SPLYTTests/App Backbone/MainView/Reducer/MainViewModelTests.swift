//
//  MainViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/20/22.
//

import XCTest
@testable import SPLYT

final class MainViewModelTests: XCTestCase {
    private var sut: MainViewModel!
    
    override func setUpWithError() throws {
        let interactor = MainViewInteractor()
        self.sut = MainViewModel(interactor: interactor)
    }
    
    func testLoadingOnInit() {
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func testSend_Load() async {
        await sut.send(.load)
        XCTAssertEqual(sut.viewState, .loaded)
    }
}
