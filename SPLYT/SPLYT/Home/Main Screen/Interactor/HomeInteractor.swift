//
//  HomeInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/23/22.
//

import Foundation
import Core

// MARK: - Domain Actions

enum HomeDomainAction {
    case load
    case deleteWorkout(id: String)
    case toggleDialog(type: HomeDialog, isOpen: Bool)
}

// MARK: - Domain Results

enum HomeDomainResult: Equatable {
    case error
    case loaded(HomeDomain)
    case dialog(type: HomeDialog, domain: HomeDomain)
}

// MARK: - Protocol

protocol HomeInteractorType {
    func interact(with: HomeDomainAction) async -> HomeDomainResult
}

// MARK: - Implementation

final class HomeInteractor: HomeInteractorType {
    private let service: HomeServiceType
    private var savedDomain: HomeDomain?
    
    init(service: HomeServiceType = HomeService()) {
        self.service = service
    }
    
    func interact(with action: HomeDomainAction) async -> HomeDomainResult {
        switch action {
        case .load:
            return handleLoad()
        case .deleteWorkout(let id):
            return handleDeleteWorkout(id: id)
        case let .toggleDialog(type, isOpen):
            return handleToggleDialog(type: type, isOpen: isOpen)
        }
    }
}

// MARK: - Private Handlers

private extension HomeInteractor {
    func handleLoad() -> HomeDomainResult {
        do {
            let workouts = try service.loadWorkouts()
            let domain = HomeDomain(workouts: workouts)
            
            // Update the saved domain
            savedDomain = domain
            return .loaded(domain)
        } catch {
            return .error
        }
    }
    
    func handleDeleteWorkout(id: String) -> HomeDomainResult {
        guard var domain = savedDomain else { return .error }
        
        do {
            // Remove the workout
            domain.workouts.removeAll { $0.workout.id == id}
            
            // Save the results
            try service.saveWorkouts(domain.workouts)
            return updateDomain(domain)
        } catch {
            return .error
        }
    }
    
    func handleToggleDialog(type: HomeDialog, isOpen: Bool) -> HomeDomainResult {
        guard let domain = savedDomain else { return .error }
        
        return isOpen ? .dialog(type: type, domain: domain) : .loaded(domain)
    }
}

// MARK: - Other Private Helpers

private extension HomeInteractor {
    func updateDomain(_ newDomain: HomeDomain) -> HomeDomainResult {
        self.savedDomain = newDomain
        return .loaded(newDomain)
    }
}
