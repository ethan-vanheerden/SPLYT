//
//  NameWorkoutViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/6/23.
//

import Foundation
import Core
import DesignSystem

/// This aspect of the flow is very simple since it is just the entry point -- so we can remove some layers from the arch
final class NameWorkoutViewModel: ViewModel {
    typealias Event = NoViewEvent
    @Published private(set) var viewState = NameWorkoutViewState()
}

// MARK: - View State

struct NameWorkoutViewState: Equatable {
    let navBar: NavigationBarViewState = NavigationBarViewState(id: "nav bar",
                                                                title: "CREATE WORKOUT")
}
