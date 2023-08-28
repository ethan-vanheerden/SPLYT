import Core

public final class MockScreenLocker: ScreenLockerType {
    public private(set) var autoLockOn = true
    
    public init() { }
    
    public func disableAutoLock() {
        autoLockOn = false
    }
    
    public func enableAutoLock() {
        autoLockOn = true
    }
}
