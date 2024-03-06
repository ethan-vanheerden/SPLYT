//
//  ScreenLocker.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/16/23.
//

import Foundation
import UIKit

/// Protocol to abstract the behavior for turning on/off screen auto-lock
public protocol ScreenLockerType {
    func disableAutoLock()
    func enableAutoLock()
}

// MARK: - Implementation

public struct ScreenLocker: ScreenLockerType {
    public init() { }
    
    public func disableAutoLock() {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    public func enableAutoLock() {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}
