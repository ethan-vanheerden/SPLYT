import Foundation

public struct Notification: Equatable {
    let id: String
    let type: NotificationType
    let title: String
    let description: String
    let additionalInfo: [String: String]?
    let isTimeSensitive: Bool
    
    public init(id: String,
                type: NotificationType,
                title: String,
                description: String,
                additionalInfo: [String : String]? = nil,
                isTimeSensitive: Bool = false) {
        self.id = id
        self.type = type
        self.title = title
        self.description = description
        self.additionalInfo = additionalInfo
        self.isTimeSensitive = isTimeSensitive
    }
}
