//
//  MockRestPresetsService.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 8/3/23.
//

import Foundation
@testable import SPLYT

final class MockRestPresetsService: RestPresetsServiceType {
    typealias Fixtures = RestPresetsFixtures
    private(set) var presets = Fixtures.presets

    private(set) var getPresetsCalled = false
    func getPresets() -> [Int] {
        getPresetsCalled = true
        return presets
    }

    private(set) var updatePresetsCalled = false
    func updatePresets(newPresets: [Int]) {
        updatePresetsCalled = true
        presets = newPresets
    }
}
