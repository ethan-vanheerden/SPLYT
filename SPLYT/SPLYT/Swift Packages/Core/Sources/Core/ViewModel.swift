import Foundation

public protocol ViewModel: ObservableObject {
    /// The published state that views will subscribe to
    associatedtype ViewState
    /// The events that a `View` can send to its `ViewModel`
    associatedtype Event
    
    var viewState: ViewState { get }
    
    func send(_ event: Event) async
}

public extension ViewModel {
    
    /// Sends an event from a view within a non-async context
    /// - Parameters:
    ///   - event: The event to send
    ///   - taskPriority: The priority that the task should be completed with
    func send(_ event: Event, taskPriority: TaskPriority = .userInitiated) {
        Task(priority: taskPriority) {
            await send(event)
        }
    }
}
