//
//  SettingsInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/7/22.
//

import Foundation
import Networking

// MARK: - Domain Event

enum SettingsDomainEvent {
    case load
}

// MARK: - Domain State

enum SettingsDomainState {
    case loaded
    case error
}

// MARK: - Protocol

protocol SettingsInteractorType {
    func interact(with: SettingsDomainEvent) async -> SettingsDomainState
}

// MARK: - Implementation
final class SettingsInteractor: SettingsInteractorType {
    func interact(with event: SettingsDomainEvent) async -> SettingsDomainState {
        switch event {
        case .load:
            return handleLoad()
        }
    }
}


// MARK: - Private
// (This is just for testing purposes, we will normally want another class/struct to delegate the actual networking layer to)

private extension SettingsInteractor {
    func handleLoad() -> SettingsDomainState {
        return .error
    }
}


struct TestNetworkRequest: NetworkRequest {
    typealias Response = TestNetworkObject
    
    func createRequest() -> URLRequest {
        <#code#>
    }
    
    
}



struct TestNetworkObject: Codable {
    let title: String
    let subtitle: String
}
