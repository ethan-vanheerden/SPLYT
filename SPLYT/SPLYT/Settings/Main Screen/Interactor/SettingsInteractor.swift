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
    case signOut
    case toggleDialog(type: SettingsDialog, isOpen: Bool)
}

// MARK: - Domain Results

enum SettingsDomainResult: Equatable {
    case error
    case loaded(SettingsDomain)
    case dialog(type: SettingsDialog, domain: SettingsDomain)
}

// MARK: - Interactor

final class SettingsInteractor {
    private var savedDomain: SettingsDomain?
    private let service: SettingsServiceType
    private let versionInteractor: VersionInteractorType
    
    init(service: SettingsServiceType = SettingsService(),
         versionInteractor: VersionInteractorType = VersionInteractor()) {
        self.service = service
        self.versionInteractor = versionInteractor
    }
    
    func interact(with action: SettingsDomainAction) async -> SettingsDomainResult {
        switch action {
        case .load:
            return handleLoad()
        case .signOut:
            return handleSignOut()
        case let .toggleDialog(type, isOpen):
            return handleToggleDialog(type: type, isOpen: isOpen)
        }
    }
}

// MARK: - Private Handlers

private extension SettingsInteractor {
    func handleLoad() -> SettingsDomainResult {
        let domain = SettingsDomain(sections: sections,
                                    versionString: versionInteractor.versionString,
                                    buildNumberString: versionInteractor.buildNumberString)
        
        return updateDomain(domain: domain)
    }
    
    func handleSignOut() -> SettingsDomainResult {
        guard let domain = savedDomain else { return .error }
        
        let success = service.signOut()
        
        return success ? updateDomain(domain: domain) : .error
    }
    
    func handleToggleDialog(type: SettingsDialog, isOpen: Bool) -> SettingsDomainResult {
        guard let domain = savedDomain else { return .error }
        
        return isOpen ? .dialog(type: type, domain: domain) : .loaded(domain)
        
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
                        .signOut
                     ],
                     isEnabled: true)
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let workout = "WORKOUT"
    static let developer = "DEVELOPER"
    static let customization = "CUSTOMIZATION"
    static let support = "SUPPORT"
}
