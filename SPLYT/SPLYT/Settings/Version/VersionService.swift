//
//  VersionService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/27/24.
//

import Foundation

protocol VersionServicing {
    var versionString: String? { get }
    var buildNumberString: String? { get }
}

struct VersionService: VersionServicing {
    var versionString: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildNumberString: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
}
