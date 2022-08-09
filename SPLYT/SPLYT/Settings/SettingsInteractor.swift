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
    case loaded(TestNetworkObject)
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
            return await handleLoad()
        }
    }
}


// MARK: - Private
// (This is just for testing purposes, we will normally want another class/struct to delegate the actual networking layer to)

private extension SettingsInteractor {
    func handleLoad() async -> SettingsDomainState {
        do {
            let response = try await APIInteractor.performRequest(with: TestNetworkRequest())
            return .loaded(response.responseObject)
        } catch {
            print(error)
            return .error
        }
        
    }
}


struct TestNetworkRequest: NetworkRequest {
    typealias Response = TestNetworkObject
    
    func createRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: "http://splyt-dev.us-east-1.elasticbeanstalk.com/object")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }
}



struct TestNetworkObject: Codable, Equatable {
    let title: String
    let subtitle: String
}
