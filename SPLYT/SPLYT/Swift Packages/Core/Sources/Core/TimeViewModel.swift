import Foundation
import Combine

/// Abstract class for time keeping in view models
open class TimeViewModel<T, U>: ViewModel {
    public typealias Event = U
    @Published public var viewState: T
    /// The number of seconds that have elapsed since this view model started keeping track of time.
    @Published public private(set) var secondsElapsed: Int = 0
    private var timeStarted: Date?
    private var isPaused: Bool = false
    private var cancellable = Set<AnyCancellable>()
    
    public init(viewState: T) {
        self.viewState = viewState
    }
    
    /// This should be overriden (has to be `open` so we can do that).
    open func send(_ event: U) async {
        return
    }
    
    /// Starts keeping track of time.
    @MainActor
    public func startTime() {
        timeStarted = Date()
        // Publish every 0.5 seconds to ensure we don't lag
        Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self,
                      let timeStarted = timeStarted else { return }
                let currentTime = Date()
                self.secondsElapsed = Int(currentTime.timeIntervalSince(timeStarted))
            }
            .store(in: &cancellable)
    }
    
    /// Stops the current time-keeping session.
    @MainActor
    public func stopTime() {
        cancellable.removeAll()
        timeStarted = nil
        secondsElapsed = 0
    }
}
