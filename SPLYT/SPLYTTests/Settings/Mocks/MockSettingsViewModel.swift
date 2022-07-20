//
//  MockSettingsViewModel.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/20/22.
//

import Foundation
@testable import SPLYT
import Core

final class MockSettingsViewModel: ViewModel {
    @Published var viewState: SettingsViewState = .loading
    
    func send(_ event: SettingsViewEvent) async { }
}
