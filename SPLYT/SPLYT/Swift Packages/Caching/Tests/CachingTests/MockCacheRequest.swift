import Caching

struct MockCacheRequest: CacheRequest {
    typealias CacheData = String
    
    var filename: String = "mock_data_test"
}
