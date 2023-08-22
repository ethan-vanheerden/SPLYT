//
//  ScreenLocker.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/16/23.
//

import Foundation
import UIKit

/// Protocol to abstract the behavior for turning on/off screen auto-lock
protocol ScreenLockerType {
    func disableAutoLock()
    func enableAutoLock()
}

// MARK: - Implementation

struct ScreenLocker: ScreenLockerType {
    func disableAutoLock() {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
    
    func enableAutoLock() {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
}

