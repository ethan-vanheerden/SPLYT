import UserAuth

final class MockUserAuth: UserAuthType {
    private(set) var signedIn = true
    
    public private(set) var createUserSuccess = true
    public func createUser(email: String, password: String) async -> Bool {
        signedIn = createUserSuccess
        return createUserSuccess
    }
    
    public private(set) var loginSuccess = true
    public func login(email: String, password: String) async -> Bool {
        signedIn = loginSuccess
        return loginSuccess
    }
    
    public private(set) var logoutSuccess = true
    @discardableResult
    func logout() -> Bool {
        signedIn = logoutSuccess ? false : signedIn
        return logoutSuccess
    }
    
    func isUserSignedIn(completion: @escaping (Bool) -> Void) {
        completion(signedIn)
    }
    
    public var stubAuthToken = "token"
    func getAuthToken() async -> String? {
        return stubAuthToken
    }
}
