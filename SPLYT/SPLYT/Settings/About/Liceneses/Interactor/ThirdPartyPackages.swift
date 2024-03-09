//
//  License.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/9/24.
//

import Foundation

// Models for decoding packages from the Package.resolved file

struct LicenseDTO: Codable, Equatable {
    let title: String
    let location: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "identity"
        case location
    }
}

struct ThirdPartyPackages: Codable, Equatable {
    let licenses: [LicenseDTO]
    
    private enum CodingKeys: String, CodingKey {
        case licenses = "pins"
    }
}
