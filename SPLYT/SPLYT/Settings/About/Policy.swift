//
//  Policyt.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 3/7/24.
//

import Foundation

/// Holds the URLs for the app's policies.
enum Policy: Hashable, CaseIterable {
    case termsConditions
    case privacyPolicy
    case endUserLicenseAgreement
    
    var title: String {
        switch self {
        case .termsConditions:
            return "Terms and Conditions"
        case .privacyPolicy:
            return "Privacy Policy"
        case .endUserLicenseAgreement:
            return "End User License Agreement"
        }
    }
    
    var url: URL? {
        let basePath = "https://ethan-vanheerden.github.io/splyt-terms/"
        
        switch self {
        case .termsConditions:
            return URL(string: basePath + "terms-conditions")
        case .privacyPolicy:
            return URL(string: basePath + "privacy-policy")
        case .endUserLicenseAgreement:
            return URL(string: basePath + "eula")
        }
    }
}
