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
    private var savedDomain: SettingsDomain?
    private let versionService: VersionServicing
    
    init(versionService: VersionServicing = VersionService()) {
        self.versionService = versionService
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
        let domain = SettingsDomain(sections: sections,
                                    versionString: versionService.versionString,
                                    buildNumberString: versionService.buildNumberString)
        
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
            customizationSection,
            supportSection,
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
    
    var customizationSection: SettingsSection {
        return .init(title: Strings.customization,
                     items: [
                        .appearance
                     ],
                     isEnabled: true)
    }
    
    var developerSection: SettingsSection {
        var isEnabled = false
#if DEBUG
        isEnabled = true
#endif
        return .init(title: Strings.developer,
                     items: [
                        .designShowcase
                     ],
                     isEnabled: isEnabled)
    }
    
    var supportSection: SettingsSection {
        return .init(title: Strings.support,
                     items: [
                        .submitFeedback,
                        .about,
                        .account
                     ],
                     isEnabled: true)
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let workout = "Workout"
    static let developer = "Developer"
    static let customization = "Customization"
    static let support = "Support"
}
