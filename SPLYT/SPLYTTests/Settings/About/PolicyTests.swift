//
//  PolicyTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 3/11/24.
//

import XCTest
@testable import SPLYT

final class PolicyTests: XCTestCase {
    
    func testTitle() {
        XCTAssertEqual(Policy.termsConditions.title, "Terms and Conditions")
        XCTAssertEqual(Policy.privacyPolicy.title, "Privacy Policy")
        XCTAssertEqual(Policy.endUserLicenseAgreement.title, "End User License Agreement")
    }
    
    func testURL() {
        let basePath = "https://ethan-vanheerden.github.io/splyt-terms/"
        
        XCTAssertEqual(Policy.termsConditions.url, URL(string: basePath + "terms-conditions"))
        XCTAssertEqual(Policy.privacyPolicy.url, URL(string: basePath + "privacy-policy"))
        XCTAssertEqual(Policy.endUserLicenseAgreement.url, URL(string: basePath + "eula"))
    }
}
