//
//  SettingsViewTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/20/22.
//

import XCTest
@testable import SPLYT
import SnapshotTesting
import SwiftUI
import DesignSystem

final class SettingsViewTests: XCTestCase {
    private var mockViewModel: MockSettingsViewModel!
    private var sut: SettingsView<MockSettingsViewModel>!
    private var vc: UIViewController!
    
    override func setUp() {
        mockViewModel = MockSettingsViewModel()
        sut = SettingsView(viewModel: mockViewModel,
                           navigationRouter: SettingsNavigationRouter())
        vc = UIHostingController(rootView: sut)
    }
    
    func testView_Loading() {
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
    
    func testView_Main() {
        let items: [MenuItemViewState] = [
            MenuItemViewState(id: SettingsItem.designShowcase, title: "DESIGN SHOWCASE")
        ]
        mockViewModel.viewState = .main(items: items)
        
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
}
