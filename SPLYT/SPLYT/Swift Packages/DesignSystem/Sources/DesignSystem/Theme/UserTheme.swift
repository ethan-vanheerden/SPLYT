import SwiftUI

public final class UserTheme: ObservableObject {
    @AppStorage(ThemeStorage.userTheme.rawValue) private var userTheme: SplytColor = .blue
    
    private init() { }
    
    public static let shared: UserTheme = {
        let instance = UserTheme()
        return instance
    }()
    
    public var theme: SplytColor {
        return userTheme
    }
}
