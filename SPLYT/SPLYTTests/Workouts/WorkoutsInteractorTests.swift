//
//  WorkoutsInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import XCTest
@testable import SPLYT

final class WorkoutsInteractorTests: XCTestCase {
    private var sut: WorkoutsInteractor!

    override func setUp() async throws {
        sut = WorkoutsInteractor()
    }
    
    func testInteract_Load() async {
        let domain = await sut.interact(with: .loadWorkouts)
        XCTAssertEqual(domain, .loaded([]))
    }
}
