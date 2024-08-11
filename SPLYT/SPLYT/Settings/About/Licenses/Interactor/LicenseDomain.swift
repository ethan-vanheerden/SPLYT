//
//  LicenseDomain.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/9/24.
//

import Foundation

struct LicenseDomain: Equatable {
    let licenses: [License]
}

struct License: Equatable {
    let name: String
    let licenseURL: URL
}

enum ThirdPartyPackage: String, Equatable, CaseIterable {
    case abseil = "abseil-cpp-binary"
    case appCheck = "app-check"
    case firebaseiOS = "firebase-ios-sdk"
    case googleAppMeasurement = "googleappmeasurement"
    case googleDataTransport = "googledatatransport"
    case googleUtilities = "googleutilities"
    case grpcBinary = "grpc-binary"
    case gtmSessionFetcher = "gtm-session-fetcher"
    case interopForGoogle = "interop-ios-for-google-sdks"
    case levelDB = "leveldb"
    case nanoPB = "nanopb"
    case promises = "promises"
    case swiftProtobuf = "swift-protobuf"
    case swiftSnapshotTesting = "swift-snapshot-testing"
    case swiftuiIntrospect = "swiftui-introspect"
    
    var path: String {
        switch self {
        case .abseil:
            return "https://github.com/google/abseil-cpp-binary/blob/main/LICENSE"
        case .appCheck:
            return "https://github.com/google/app-check/blob/main/LICENSE"
        case .firebaseiOS:
            return "https://github.com/firebase/firebase-ios-sdk/blob/main/LICENSE"
        case .googleAppMeasurement:
            return "https://github.com/google/GoogleAppMeasurement/blob/main/LICENSE"
        case .googleDataTransport:
            return "https://github.com/google/GoogleDataTransport/blob/main/LICENSE"
        case .googleUtilities:
            return "https://github.com/google/GoogleUtilities/blob/main/LICENSE"
        case .grpcBinary:
            return "https://github.com/google/grpc-binary/blob/main/LICENSE"
        case .gtmSessionFetcher:
            return "https://github.com/google/gtm-session-fetcher/blob/main/LICENSE"
        case .interopForGoogle:
            return "https://github.com/google/interop-ios-for-google-sdks/blob/main/LICENSE"
        case .levelDB:
            return "https://github.com/firebase/leveldb/blob/firebase-release/LICENSE"
        case .nanoPB:
            return "https://github.com/firebase/nanopb/blob/master/LICENSE.txt"
        case .promises:
            return "https://github.com/google/promises/blob/master/LICENSE"
        case .swiftProtobuf:
            return "https://github.com/apple/swift-protobuf/blob/main/LICENSE.txt"
        case .swiftSnapshotTesting:
            return "https://github.com/pointfreeco/swift-snapshot-testing/blob/main/LICENSE"
        case .swiftuiIntrospect:
            return "https://github.com/siteline/swiftui-introspect/blob/main/LICENSE"
        }
    }
}
