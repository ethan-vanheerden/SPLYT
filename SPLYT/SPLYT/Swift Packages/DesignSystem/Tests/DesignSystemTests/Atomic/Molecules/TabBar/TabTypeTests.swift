//
//  TabTypeTests.swift
//  
//
//  Created by Ethan Van Heerden on 3/10/23.
//

import XCTest
@testable import DesignSystem

final class TabTypeTests: XCTestCase {
    func testIconName() {
        let baseImageNames: [TabSelection: String] = [.home: "house", .history: "book", .settings: "gearshape"]
        let selectedImageNames: [TabSelection: String] = [.home: "house.fill", .history: "book.fill", .settings: "gearshape.fill"]
        
        TabSelection.allCases.forEach { tab in
            XCTAssertEqual(tab.imageName(isSelected: false), baseImageNames[tab])
            XCTAssertEqual(tab.imageName(isSelected: true), selectedImageNames[tab])
        }
    }
    
    func testTitle() {
        XCTAssertEqual(TabSelection.home.title, "Home")
        XCTAssertEqual(TabSelection.history.title, "History")
        XCTAssertEqual(TabSelection.settings.title, "Settings")
    }
}
