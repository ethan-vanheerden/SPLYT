//
//  RestPresetsReducer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/1/23.
//

import Foundation
import Core

struct RestPresetsReducer {
    func reduce(_ domain: RestPresetsDomainResult) -> RestPresetsViewState {
        switch domain {
        case .error:
            return .error
        case .loaded(let domain):
            let display = getDisplay(domain: domain)
            return .loaded(display)
        }
    }
}

// MARK: - Private

private extension RestPresetsReducer {
    func getDisplay(domain: RestPresetsDomain) -> RestPresetsDisplay {
        let presetsDisplay = getPresets(presets: domain.presets)
        return .init(presets: presetsDisplay)
    }
    
    func getPresets(presets: [Int]) -> [PresetDisplay] {
        var index = 0
        return presets.map { preset in
            let viewState = PresetDisplay(index: index,
                                                title: TimeUtils.minSec(seconds: preset),
                                                preset: preset,
                                                minutes: TimeUtils.minutesElapsed(seconds: preset),
                                                seconds: TimeUtils.secondsElapsed(seconds: preset))
            index += 1
            return viewState
        }
    }
}
