//
//  LicenseInteractor.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/9/24.
//

import Foundation

// MARK: - Domain Actions

enum LicenseDomainAction {
    case load
}

// MARK: - Domain Results

enum LicenseDomainResult: Equatable {
    case error
    case loaded(LicenseDomain)
}

// MARK: - Interactor

final class LicenseInteractor {
    private let service: LicenseServiceType
    private var savedDomain: LicenseDomain?
    
    init(service: LicenseServiceType = LicenseService()) {
        self.service = service
    }
    
    func interact(with action: LicenseDomainAction) async -> LicenseDomainResult {
        switch action {
        case .load:
            return handleLoad()
        }
    }
}

// MARK: - Private Handlers

private extension LicenseInteractor {
    func handleLoad() -> LicenseDomainResult {
        do {
            let packages = try service.loadPackages()
            let licenses: [License] = packages.licenses.compactMap { packageLicense in
                guard let licenseURL = getLicenseURL(basePath: packageLicense.location) else {
                    return nil
                }
                return License(title: packageLicense.title,
                               licenseURL: licenseURL)
            }
            
            let domain = LicenseDomain(licenses: licenses)
            return updateDomain(domain: domain)
        } catch {
            return .error
        }
    }
}

// MARK: - Other Private Helpers

private extension LicenseInteractor {
    
    /// Updates and saves the domain object.
    /// - Parameters:
    ///   - domain: The old domain to update
    /// - Returns: The loaded domain state after updating the domain object
    func updateDomain(domain: LicenseDomain) -> LicenseDomainResult {
        savedDomain = domain
        return .loaded(domain)
    }
    
    /// Generates the URL to where the third-party package's license is.
    /// - Parameter basePath: The base path for the third-party repo
    /// - Returns: The URL pointing to the license, if it exists
    func getLicenseURL(basePath: String) -> URL? {
        // Remote the .git at the end or the path if present
        let gitRemoved = basePath.split(separator: ".git")
        let baseURL = URL(string: String(gitRemoved[0]))
        return baseURL?.appendingPathComponent("blob/main/LICENSE")
    }
}
