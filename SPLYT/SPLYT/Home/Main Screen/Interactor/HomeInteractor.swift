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
    case deleteWorkout(id: String) // TODO: add dialog action here, edit workout skeleton, tests
}

// MARK: - Domain Results

enum HomeDomainResult: Equatable {
    case error
    case loaded(HomeDomain)
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
            domain.workouts = domain.workouts.filter { $0.id != id }
            
            // Save the results
            try service.saveWorkouts(domain.workouts)
            return updateDomain(domain)
        } catch {
            return .error
        }
    }
}

// MARK: - Other Private Helpers

private extension HomeInteractor {
    func updateDomain(_ newDomain: HomeDomain) -> HomeDomainResult {
        self.savedDomain = newDomain
        return .loaded(newDomain)
    }
}
