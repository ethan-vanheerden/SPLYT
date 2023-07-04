import Caching

struct CreatedRoutinesCacheRequest: CacheRequest {
    // Dictionary of the workout ID to its associated object
    typealias CacheData = CreatedRoutines
    let filename: String = "user_created_routines"
}
