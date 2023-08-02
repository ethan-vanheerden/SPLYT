//
//  RestPresetsInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/1/23.
//

import Foundation
import Core

// MARK: - Domain Actions

enum RestPresetsDomainAction {
    case load
    case updatePresets(newPresets: [Int])
    case updatePreset(index: Int, minutes: Int, seconds: Int)
}

// MARK: - Domain Results

enum RestPresetsDomainResult: Equatable {
    case error
    case loaded(RestPresetsDomain)
}

// MARK: - Interactor

final class RestPresetsInteractor {
    private let service: RestPresetsServiceType
    private var savedDomain: RestPresetsDomain?
    
    init(service: RestPresetsServiceType = RestPresetsService()) {
        self.service = service
    }
    
    func interact(with action: RestPresetsDomainAction) async -> RestPresetsDomainResult {
        switch action {
        case .load:
            return handleLoad()
        case .updatePresets(let newPresets):
            return handleUpdatePresets(newPresets: newPresets)
        case let .updatePreset(index, minutes, seconds):
            return handleUpdatePreset(index: index, minutes: minutes, seconds: seconds)
        }
    }
}

// MARK: - Private Handlers

private extension RestPresetsInteractor {
    func handleLoad() -> RestPresetsDomainResult {
        let presets = service.getPresets()
        let domain = RestPresetsDomain(presets: presets)
        
        return updateDomain(domain: domain)
    }
    
    func handleUpdatePresets(newPresets: [Int]) -> RestPresetsDomainResult {
        guard var domain = savedDomain else { return .error }
        
        return updatePresets(domain: &domain, newPresets: newPresets)
        
        service.updatePresets(newPresets: newPresets)
    }
    
    func handleUpdatePreset(index: Int, minutes: Int, seconds: Int) -> RestPresetsDomainResult {
        guard var domain = savedDomain,
              domain.presets.count > index else { return .error }
        
        var newPresets = domain.presets
        newPresets[index] = TimeUtils.getSeconds(minutes: minutes, seconds: seconds)
        
        return updatePresets(domain: &domain, newPresets: newPresets)
    }
}

// MARK: - Other Private Helpers

private extension RestPresetsInteractor {
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The old domain to update
    /// - Returns: The loaded domain state after updating the domain object
    func updateDomain(domain: RestPresetsDomain) -> RestPresetsDomainResult {
        savedDomain = domain
        return .loaded(domain)
    }
    
    /// Updates the user's rest presets and updates the saved domain.
    /// - Parameters:
    ///   - domain: The saved domain to update
    ///   - newPresets: The user's new presets
    /// - Returns: The new domain result with the updated presets
    func updatePresets(domain: inout RestPresetsDomain, newPresets: [Int]) -> RestPresetsDomainResult {
        service.updatePresets(newPresets: newPresets)
        let presets = service.getPresets() // Load to ensure they were updated
        
        domain.presets = presets
        
        return updateDomain(domain: domain)
    }
}
