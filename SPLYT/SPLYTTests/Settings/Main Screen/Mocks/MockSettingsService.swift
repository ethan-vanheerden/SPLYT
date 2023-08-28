//
//  MockSettingsService.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import Foundation
@testable import SPLYT

final class MockSettingsService: SettingsServiceType {
    var signOutSuccess = true
    func signOut() -> Bool {
        return signOutSuccess
    }
}
