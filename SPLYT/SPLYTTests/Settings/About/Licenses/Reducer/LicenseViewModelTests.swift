//
//  LicenseViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 3/11/24.
//

import XCTest
@testable import SPLYT

final class LicenseViewModelTests: XCTestCase {
    typealias Fixtures = LicenseFixtures
    private var sut: LicenseViewModel!
    private var interactor: LicenseInteractor!
    
    override func setUpWithError() throws {
        interactor = LicenseInteractor()
        sut = LicenseViewModel(interactor: interactor)
    }
    
    func testLoadingOnInit() {
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func testSend_Load() async {
        await sut.send(.load)
        
        XCTAssertEqual(sut.viewState, .loaded(Fixtures.display))
    }
}
