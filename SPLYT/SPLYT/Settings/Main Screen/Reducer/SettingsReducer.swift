//
//  SettingsReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/31/23.
//

import Foundation
import DesignSystem

struct SettingsReducer {
    func reduce(_ domain: SettingsDomainResult) -> SettingsViewState {
        switch domain {
        case .error:
            return .error
        case .loaded(let domain):
            let display = getDisplay(domain: domain)
            return .loaded(display)
        }
    }
}

// MARK: - Private

private extension SettingsReducer {
    func getDisplay(domain: SettingsDomain) -> SettingsDisplay {
        return .init(sections: domain.sections,
                     versionString: domain.versionString,
                     buildNumberString: domain.buildNumberString)
    }
}
