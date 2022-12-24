//
//  ItemViewState.swift
//  
//
//  Created by Ethan Van Heerden on 7/16/22.
//

/// Represents a view state which can be used to construct many views throughout the app.
public protocol ItemViewState {
    var id: AnyHashable { get }
    func isEqualTo(_ other: any ItemViewState) -> Bool
}

public extension ItemViewState where Self: Equatable {
    func isEqualTo(_ other: any ItemViewState) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
}

/// Wrapper for ItemViewStates to work with Equatable conformance
public struct ItemViewStateWrapper: ItemViewState, Equatable {
    public let state: ItemViewState
    public var id: AnyHashable { state.id }
    
    public init(state: ItemViewState) {
        self.state = state
    }
    
    public static func == (lhs: ItemViewStateWrapper, rhs: ItemViewStateWrapper) -> Bool {
        return lhs.isEqualTo(rhs)
    }
}
