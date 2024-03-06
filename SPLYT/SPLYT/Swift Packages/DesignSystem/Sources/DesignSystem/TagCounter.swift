import Foundation

class TagCounter {
    private var tagCount = 0;
    
    static let shared = TagCounter()
    
    func getTag() -> Int {
        tagCount += 1
        return tagCount
    }
}
