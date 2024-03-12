//
//  ThirdPartyPackageTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 3/11/24.
//

import XCTest
@testable import SPLYT

final class ThirdPartyPackageTests: XCTestCase {
    typealias sut = ThirdPartyPackage
    
    func testName() {
        XCTAssertEqual(sut.abseil.rawValue, "abseil-cpp-binary")
        XCTAssertEqual(sut.firebaseiOS.rawValue, "firebase-ios-sdk")
        XCTAssertEqual(sut.googleAppMeasurement.rawValue, "googleappmeasurement")
        XCTAssertEqual(sut.googleDataTransport.rawValue, "googledatatransport")
        XCTAssertEqual(sut.googleUtilities.rawValue, "googleutilities")
        XCTAssertEqual(sut.grpcBinary.rawValue, "grpc-binary")
        XCTAssertEqual(sut.gtmSessionFetcher.rawValue, "gtm-session-fetcher")
        XCTAssertEqual(sut.levelDB.rawValue, "leveldb")
        XCTAssertEqual(sut.nanoPB.rawValue, "nanopb")
        XCTAssertEqual(sut.promises.rawValue, "promises")
        XCTAssertEqual(sut.swiftProtobuf.rawValue, "swift-protobuf")
        XCTAssertEqual(sut.swiftSnapshotTesting.rawValue, "swift-snapshot-testing")
    }
    
    func testPath() {
        XCTAssertEqual(sut.abseil.path,
                       "https://github.com/google/abseil-cpp-binary/blob/main/LICENSE")
        XCTAssertEqual(sut.firebaseiOS.path,
                       "https://github.com/firebase/firebase-ios-sdk/blob/main/LICENSE")
        XCTAssertEqual(sut.googleAppMeasurement.path,
                       "https://github.com/google/GoogleAppMeasurement/blob/main/LICENSE")
        XCTAssertEqual(sut.googleDataTransport.path,
                       "https://github.com/google/GoogleDataTransport/blob/main/LICENSE")
        XCTAssertEqual(sut.googleUtilities.path,
                       "https://github.com/google/GoogleUtilities/blob/main/LICENSE")
        XCTAssertEqual(sut.grpcBinary.path,
                       "https://github.com/google/grpc-binary/blob/main/LICENSE")
        XCTAssertEqual(sut.gtmSessionFetcher.path,
                       "https://github.com/google/gtm-session-fetcher/blob/main/LICENSE")
        XCTAssertEqual(sut.levelDB.path,
                       "https://github.com/firebase/leveldb/blob/firebase-release/LICENSE")
        XCTAssertEqual(sut.nanoPB.path,
                       "https://github.com/firebase/nanopb/blob/master/LICENSE.txt")
        XCTAssertEqual(sut.promises.path,
                       "https://github.com/google/promises/blob/master/LICENSE")
        XCTAssertEqual(sut.swiftProtobuf.path,
                       "https://github.com/apple/swift-protobuf/blob/main/LICENSE.txt")
        XCTAssertEqual(sut.swiftSnapshotTesting.path,
                       "https://github.com/pointfreeco/swift-snapshot-testing/blob/main/LICENSE")
    }
}
