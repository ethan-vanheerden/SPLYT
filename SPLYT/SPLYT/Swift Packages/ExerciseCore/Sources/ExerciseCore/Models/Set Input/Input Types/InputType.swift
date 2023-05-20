import Foundation

public protocol InputType: Codable, Equatable {
    var hasPlaceholder: Bool { get }
}
