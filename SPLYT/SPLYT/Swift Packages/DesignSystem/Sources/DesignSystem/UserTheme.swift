import SwiftUI

public final class UserTheme: ObservableObject {
    @AppStorage("userTheme") private var userTheme: SplytColor = .lightBlue
    
    private init() { }
    
    public static let shared: UserTheme = {
        let instance = UserTheme()
        return instance
    }()
    
    public var theme: SplytColor {
        return userTheme
    }
}
