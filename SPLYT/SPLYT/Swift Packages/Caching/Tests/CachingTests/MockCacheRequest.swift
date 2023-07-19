import Caching

struct MockCacheRequest: CacheRequest {
    typealias CacheData = String
    let filename: String = "mock_data_test"
}
