//
//  LicenseService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/9/24.
//

import Foundation

// MARK: - Protocol

protocol LicenseServiceType {
    func loadPackages() throws -> ThirdPartyPackages
}

// MARK: - Implementation

struct LicenseService: LicenseServiceType {
    func loadPackages() throws -> ThirdPartyPackages {
        // Load the licesnes from the Package.resolved file
        guard let url = Bundle.main.url(forResource: "Package", withExtension: "resolved") else {
            throw LicenseError.packageResolvedNotFound
        }
        
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(ThirdPartyPackages.self, from: data)
    }
}

// MARK: - Errors

enum LicenseError: Error {
    case packageResolvedNotFound
}
