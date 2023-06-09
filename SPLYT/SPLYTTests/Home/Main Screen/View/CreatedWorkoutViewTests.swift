//
//  CreatedWorkoutViewTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 6/8/23.
//

import XCTest
@testable import SPLYT
import SnapshotTesting
import SwiftUI
import DesignSystem

final class CreatedWorkoutViewTests: XCTestCase {
    private let viewStateOne = CreatedWorkoutViewState(id: "1",
                                                       filename: "filename-1",
                                                       title: "Legs",
                                                       subtitle: "5 exercises",
                                                       lastCompleted: "Jun. 8 2023")
    private let viewStateTwo = CreatedWorkoutViewState(id: "2",
                                                       filename: "filename-2",
                                                       title: "Chest",
                                                       subtitle: "4 exercises",
                                                       lastCompleted: nil)
    
    func testHistoryView() {
        let view = VStack {
            CreatedWorkoutView(viewState: viewStateOne,
                               tapAction: { _ in },
                               editAction: { _ in },
                               deleteAction: { _ in })
            CreatedWorkoutView(viewState: viewStateTwo,
                               tapAction: { _ in },
                               editAction: { _ in },
                               deleteAction: { _ in })
        }
            .padding(.horizontal, Layout.size(1))
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
