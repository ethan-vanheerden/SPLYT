//
//  LicenseFixtures.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 3/11/24.
//

@testable import SPLYT
import Foundation
import DesignSystem

struct LicenseFixtures {
    // MARK: - Domain
    
    static let licenses: [License] = [
        .init(name: "abseil-cpp-binary",
              licenseURL: URL(string: "https://github.com/google/abseil-cpp-binary/blob/main/LICENSE") ?? URL.homeDirectory),
        .init(name: "firebase-ios-sdk",
              licenseURL: URL(string: "https://github.com/firebase/firebase-ios-sdk/blob/main/LICENSE") ?? URL.homeDirectory),
        .init(name: "googleappmeasurement",
              licenseURL: URL(string: "https://github.com/google/GoogleAppMeasurement/blob/main/LICENSE") ?? URL.homeDirectory),
        .init(name: "googledatatransport",
              licenseURL: URL(string: "https://github.com/google/GoogleDataTransport/blob/main/LICENSE") ?? URL.homeDirectory),
        .init(name: "googleutilities",
              licenseURL: URL(string: "https://github.com/google/GoogleUtilities/blob/main/LICENSE") ?? URL.homeDirectory),
        .init(name: "grpc-binary",
              licenseURL: URL(string: "https://github.com/google/grpc-binary/blob/main/LICENSE") ?? URL.homeDirectory),
        .init(name: "gtm-session-fetcher",
              licenseURL: URL(string: "https://github.com/google/gtm-session-fetcher/blob/main/LICENSE") ?? URL.homeDirectory),
        .init(name: "leveldb",
              licenseURL: URL(string: "https://github.com/firebase/leveldb/blob/firebase-release/LICENSE") ?? URL.homeDirectory),
        .init(name: "nanopb",
              licenseURL: URL(string: "https://github.com/firebase/nanopb/blob/master/LICENSE.txt") ?? URL.homeDirectory),
        .init(name: "promises",
              licenseURL: URL(string: "https://github.com/google/promises/blob/master/LICENSE") ?? URL.homeDirectory),
        .init(name: "swift-protobuf",
              licenseURL: URL(string: "https://github.com/apple/swift-protobuf/blob/main/LICENSE.txt") ?? URL.homeDirectory),
        .init(name: "swift-snapshot-testing",
              licenseURL: URL(string: "https://github.com/pointfreeco/swift-snapshot-testing/blob/main/LICENSE") ?? URL.homeDirectory)
    ]
    
    static let domain: LicenseDomain = .init(licenses: licenses)
    
    // MARK: - View State
    
    static let licenseItems: [SettingsListItemViewState] = licenses.map {
        return .init(title: $0.name,
                     iconName: "link",
                     iconBackgroundColor: .gray,
                     link: $0.licenseURL)
    }
    
    static let display: LicenseDisplay = .init(licenses: licenseItems)
}
