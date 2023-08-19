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
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func enableAutoLock() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
}

