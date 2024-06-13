import UserNotifications

public protocol NotificationInteractorType {
    /// Requests authorization from the user to send notifications to them.
    func requestAuthorization() async throws
    
    /// Locally scedules a notification to send to the user.
    /// - Parameters:
    ///   - notification: The notification to send
    ///   - after: The number of seconds from now to send the notification
    func scheduleNotification(notification: Notification, after: Int) async throws
    
    /// Deletes a notification that was previously scheduled before it is sent to the user.
    /// - Parameter id: The id of the notification to delete
    func deleteNotification(id: String)
}

public struct NotificationInteractor: NotificationInteractorType {
    public init() { }
    
    public func requestAuthorization() async throws {
        let notificationCenter = UNUserNotificationCenter.current()
        try await notificationCenter.requestAuthorization(options: [.alert, .sound])
    }
    
    public func scheduleNotification(notification: Notification, after seconds: Int) async throws {
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.description
        content.sound = .default
        
        var userInfo = notification.additionalInfo ?? [:]
        userInfo["TYPE"] = notification.type.rawValue
        content.userInfo = userInfo
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: .init(seconds),
                                                        repeats: false)
        
        let request = UNNotificationRequest(identifier: notification.id,
                                            content: content,
                                            trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        try await notificationCenter.add(request)
    }
    
    public func deleteNotification(id: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [id])
    }
}
