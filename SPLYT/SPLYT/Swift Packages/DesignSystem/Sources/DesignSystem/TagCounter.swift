import Foundation

/// Class to handle creating unique View tags by using a monotonic increasing value.
class TagCounter {
    private var tagCount = 0;
    
    static let shared = TagCounter()
    
    func getTag() -> Int {
        tagCount += 1
        return tagCount
    }
    
    func resetCount() {
        tagCount = 0
    }
}
