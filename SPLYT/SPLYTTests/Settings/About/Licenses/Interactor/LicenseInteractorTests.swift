//
//  LicenseInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 3/11/24.
//

import XCTest
@testable import SPLYT

final class LicenseInteractorTests: XCTestCase {
    typealias Fixtures = LicenseFixtures
    private var sut: LicenseInteractor!

    override func setUpWithError() throws {
        sut = LicenseInteractor()
    }
    
    // Assert that the number of ThirdPartyPackage is equivalent to the number of packages in Package.resolved
    func testLoadAllPackages() async throws {
        let packageURL = try XCTUnwrap(Bundle.main.url(forResource: "Package", withExtension: "resolved"))
        let data = try Data(contentsOf: packageURL)
        let loadedPackages = try JSONDecoder().decode(ThirdPartyPackagesDTO.self, from: data)
        let licenses = loadedPackages.licenses.map { $0.title }
        let packages = ThirdPartyPackage.allCases
        
        packages.forEach { package in
            XCTAssertTrue(licenses.contains(package.rawValue))
        }
        XCTAssertEqual(licenses.count, packages.count)
    }
    
    func testInteract_Load() async {
        let result = await sut.interact(with: .load)
        XCTAssertEqual(result, .loaded(Fixtures.domain))
    }

}

struct LicenseDTO: Codable, Equatable {
    let title: String
    let location: String

    private enum CodingKeys: String, CodingKey {
        case title = "identity"
        case location
    }
}

struct ThirdPartyPackagesDTO: Codable, Equatable {
    let licenses: [LicenseDTO]

    private enum CodingKeys: String, CodingKey {
        case licenses = "pins"
    }
}
