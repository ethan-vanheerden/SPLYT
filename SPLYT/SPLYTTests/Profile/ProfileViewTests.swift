//
//  ProfileViewTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/20/22.
//

import XCTest
@testable import SPLYT
import SnapshotTesting
import SwiftUI

final class ProfileViewTests: XCTestCase {
    
    func testProfileView() {
        let vc = UIHostingController(rootView: ProfileView())
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
}
