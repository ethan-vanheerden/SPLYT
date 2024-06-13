import SwiftUI
import FirebaseCore
import Notifications

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        Task {
            do {
                try await NotificationInteractor().requestAuthorization()
            }  catch {
                // Nothing right now
                print("Notification setup failed")
            }
        }
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, 
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Determine if the notification should be presented
        if UIApplication.shared.applicationState == .active,
           shouldPresentNotificationWhenActive(notification: notification) {
            // App is active, ignore the notification
            print("App is active, ignoring notification")
            completionHandler([])
        } else {
            // App is not active, present the notification
            completionHandler([.banner, .sound])
        }
    }
    
    /// Determines if the given notification should be presented when the application is currently active.
    /// - Parameter notification: The notification to possibly present
    /// - Returns: Whether the notification should be presented or not
    func shouldPresentNotificationWhenActive(notification: UNNotification) -> Bool {
        let userInfo = notification.request.content.userInfo
        
        guard let type = userInfo["TYPE"] as? String else {
            return true
        }
        
        return type != NotificationType.restTimer.rawValue
    }
}
