//
//  MockAuthManager.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/28/23.
//

import Foundation
@testable import SPLYT

final class MockAuthManager: AuthManagerType {
    var isAuthenticated: Bool = true
}
