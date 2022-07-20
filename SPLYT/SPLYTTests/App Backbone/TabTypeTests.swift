//
//  TabTypeTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/20/22.
//

import XCTest
@testable import SPLYT
import SwiftUI
import SnapshotTesting

final class TabTypeTests: XCTestCase {

    func testBaseView() {
        let view = VStack {
            ForEach(TabType.allCases, id: \.self) {
                $0.baseView
            }
        }.padding(.horizontal)
        
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
    
    func testImageName() {
        let expected = ["figure.walk", "person.crop.circle", "gear"]
        let actual = TabType.allCases.map { $0.imageName }
        XCTAssertEqual(actual, expected)
    }
    
    func testTitle() {
        let expected = ["Workouts", "Profile", "Settings"]
        let actual = TabType.allCases.map { $0.title }
        XCTAssertEqual(actual, expected)
    }
}
