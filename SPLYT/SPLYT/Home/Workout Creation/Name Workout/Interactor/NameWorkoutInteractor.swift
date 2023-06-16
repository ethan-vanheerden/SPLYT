//
//  NameWorkoutInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/16/23.
//

import Foundation

// MARK: - Domain Actions

enum NameWorkoutDomainAction {
    case load
    case updateWorkoutName(name: String)
}

// MARK: - Domain Results

enum NameWorkoutDomainResult {
    case error
    case loaded(NameWorkoutDomain)
}

// MARK: - Interactor

final class NameWorkoutInteractor {
    private let buildType: NameWorkoutBuildType
    private var savedDomain: NameWorkoutDomain?
    
    init(buildType: NameWorkoutBuildType) {
        self.buildType = buildType
    }
    
    func interact(with action: NameWorkoutDomainAction) async -> NameWorkoutDomainResult {
        switch action {
        case .load:
            return handleLoad()
        case .updateWorkoutName(let name):
            return handleUpdateWorkoutName(name: name)
        }
    }
}

// MARK: - Private Handlers

private extension NameWorkoutInteractor {
    func handleLoad() -> NameWorkoutDomainResult {
        let domain = NameWorkoutDomain(workoutName: "",
                                       buildType: buildType)
        return updateDomain(domain: domain)
    }
    
    func handleUpdateWorkoutName(name: String) -> NameWorkoutDomainResult {
        guard var domain = savedDomain else { return .error }
        domain.workoutName = name
        
        return updateDomain(domain: domain)
    }
}

// MARK: - Other Private Helpers

private extension NameWorkoutInteractor {
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The old domain to update
    /// - Returns: The loaded domain state after updating the domain object
    func updateDomain(domain: NameWorkoutDomain) -> NameWorkoutDomainResult {
        savedDomain = domain
        return .loaded(domain)
    }
}
