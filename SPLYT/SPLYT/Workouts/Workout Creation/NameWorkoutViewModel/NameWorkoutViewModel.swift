//
//  NameWorkoutViewModel.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/6/23.
//

import Foundation
import Core

final class NameWorkoutViewModel: ViewModel {
    typealias Event = NoViewEvent
    
    @Published private(set) var viewState = NameWorkoutViewState()
    
    
}

// MARK: - View State

struct NameWorkoutViewState: Equatable {
    
}
