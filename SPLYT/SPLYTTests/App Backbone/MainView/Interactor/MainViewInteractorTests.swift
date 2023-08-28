//
//  MainViewInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import XCTest
@testable import SPLYT

final class MainViewInteractorTests: XCTestCase {
    private var sut: MainViewInteractor!

    override func setUpWithError() throws {
        self.sut = MainViewInteractor()
    }
    
    func testInteract_Load() async {
        let result = await sut.interact(with: .load)
        XCTAssertEqual(result, .loaded)
    }
}
