//
//  Sound.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/13/24.
//

import Foundation

enum Sound {
    case restTimer
    
    var fileName: String {
        switch self {
        case .restTimer:
            return "restTimer"
        }
    }
}
