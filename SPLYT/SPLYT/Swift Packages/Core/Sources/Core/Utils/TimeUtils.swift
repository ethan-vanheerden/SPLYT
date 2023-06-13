import Foundation

public struct TimeUtils {
    
    /// Returns a time string in the form of hours:min:sec. We make sure that the hour is 1 digit long,
    /// and the minutes and seconds are 2 digits long. Ex: 1:30:08
    /// - Parameter seconds: The number of total seconds
    /// - Returns: The formatted time string
    public static func hrMinSec(seconds: Int) -> String {
        let hours = hoursElapsed(seconds: seconds)
        let minutes = minutesElapsed(seconds: seconds)
        let seconds = secondsElapsed(seconds: seconds)
        
        return String(format: "%01d:%02d:%02d", hours, minutes, seconds)
    }
    
    /// Returns a time string in the form of min:sec. We make sure that both the minute and seconds are 2 digits long. Ex: 04:30
    /// - Parameter seconds: The number of total seconds
    /// - Returns: The formatted time string
    public static func minSec(seconds: Int) -> String {
        let minutes = minutesElapsed(seconds: seconds)
        let seconds = secondsElapsed(seconds: seconds)
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// Gets the given number of seconds in the given number of minutes and seconds.
    /// - Parameters:
    ///   - minutes: The number of minutes
    ///   - seconds: The number of seconds
    /// - Returns: The total number of seconds in the given time
    public static func getSeconds(minutes: Int, seconds: Int) -> Int {
        return (minutes * 60) + seconds
    }
}

// MARK: - Private

private extension TimeUtils {
    /// Gets the number of whole hours that have elapsed in the given number of total seconds.
    /// - Parameter seconds: The number of total seconds that have elapsed
    /// - Returns: The whole number of hours which have elapsed
    private static func hoursElapsed(seconds: Int) -> Int {
        return seconds / 3600
    }
    
    /// Gets the number of whole minutes that have elapsed in the current hour
    /// with the given number of total seconds.
    /// - Parameter seconds: The number of total seconds that have elapsed
    /// - Returns: The whole number of minutes which have elapsed in the current hour
    private static func minutesElapsed(seconds: Int) -> Int {
        return (seconds % 3600) / 60
    }
    
    /// Gets the number of whole seconds that have elapsed in the current minute
    /// with the given number of total seconds.
    /// - Parameter seconds: The number of total seconds that have elapsed
    /// - Returns: The whole number of seconds which have elapsed in the current minute
    private static func secondsElapsed(seconds: Int) -> Int {
        return seconds % 60
    }
}
