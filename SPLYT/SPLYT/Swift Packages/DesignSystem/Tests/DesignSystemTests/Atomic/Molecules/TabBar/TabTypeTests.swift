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
        let baseImageNames: [TabType: String] = [.home: "house", .history: "book", .settings: "gearshape"]
        let selectedImageNames: [TabType: String] = [.home: "house.fill", .history: "book.fill", .settings: "gearshape.fill"]
        
        TabType.allCases.forEach { tab in
            XCTAssertEqual(tab.imageName(isSelected: false), baseImageNames[tab])
            XCTAssertEqual(tab.imageName(isSelected: true), selectedImageNames[tab])
        }
    }
    
    func testTitle() {
        XCTAssertEqual(TabType.home.title, "Home")
        XCTAssertEqual(TabType.history.title, "History")
        XCTAssertEqual(TabType.settings.title, "Settings")
    }
}
