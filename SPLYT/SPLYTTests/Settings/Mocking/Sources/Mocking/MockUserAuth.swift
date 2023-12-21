import UserAuth

public final class MockUserAuth: UserAuthType {
    public private(set) var signedIn = true
    
    public init() {}
    
    public var createUserSuccess = true
    public func createUser(email: String, password: String) async -> Bool {
        signedIn = createUserSuccess
        return createUserSuccess
    }
    
    public var loginSuccess = true
    public func login(email: String, password: String) async -> Bool {
        signedIn = loginSuccess
        return loginSuccess
    }
    
    public var logoutSuccess = true
    @discardableResult
    public func logout() -> Bool {
        signedIn = logoutSuccess ? false : signedIn
        return logoutSuccess
    }
    
    public func isUserSignedIn(completion: @escaping (Bool) -> Void) {
        completion(signedIn)
    }
    
    public var stubAuthToken = "token"
    public func getAuthToken() async -> String? {
        return stubAuthToken
    }
}
