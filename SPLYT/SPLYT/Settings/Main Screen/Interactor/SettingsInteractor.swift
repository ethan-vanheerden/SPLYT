//
//  SettingsInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/31/23.
//

import Foundation

// MARK: - Domain Actions

enum SettingsDomainAction {
    case load
}

// MARK: - Domain Results

enum SettingsDomainResult: Equatable {
    case error
    case loaded(SettingsDomain)
}

// MARK: - Interactor

final class SettingsInteractor {
    private let service: SettingsServiceType
    private var savedDomain: SettingsDomain?
    
    init(service: SettingsServiceType = SettingsService()) {
        self.service = service
    }
    
    func interact(with action: SettingsDomainAction) async -> SettingsDomainResult {
        switch action {
        case .load:
            return handleLoad()
        }
    }
}

// MARK: - Private Handlers

private extension SettingsInteractor {
    func handleLoad() -> SettingsDomainResult {
        let domain = SettingsDomain(sections: sections)
        
        return updateDomain(domain: domain)
    }
}

// MARK: - Other Private Helpers

private extension SettingsInteractor {
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The old domain to update
    /// - Returns: The loaded domain state after updating the domain object
    func updateDomain(domain: SettingsDomain) -> SettingsDomainResult {
        savedDomain = domain
        return .loaded(domain)
    }
    
    var sections: [SettingsSection] {
        return [
            workoutSection,
            developerSection
        ]
    }
    
    var workoutSection: SettingsSection {
        return .init(title: Strings.workout,
                     items: [
                        .restPresets
                     ],
                     isEnabled: true)
    }
    
    var developerSection: SettingsSection {
        return .init(title: Strings.developer,
                     items: [
                        .designShowcase
                     ],
                     isEnabled: true) // TODO:
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let workout = "WORKOUT"
    static let developer = "DEVELOPER"
}
