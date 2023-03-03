//
//  MockWorkoutsViewModel.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 12/29/22.
//

import Foundation
import Core
@testable import SPLYT

final class MockWorkoutsViewModel: ViewModel {
    @Published var viewState: HomeViewState = .loading
    
    func send(_ event: HomeViewEvent) async { }
}
