
public protocol NavigationRouter {
    associatedtype Event
    
    func navigate(_ event: Event)
}
