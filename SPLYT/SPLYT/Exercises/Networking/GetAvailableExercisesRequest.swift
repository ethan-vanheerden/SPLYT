//
//  GetAvailableExercisesRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/13/22.
//

import Foundation
import Networking
import ExerciseCore

/// Gets a list of all of the exercises that the user is able to do.
struct GetAvailableExercisesRequest: NetworkRequest {
    typealias Response = [AvailableExercise]
    
    func createRequest() -> URLRequest {
        let url = URL(string: "https://exercises-2iropnvq6q-uc.a.run.app")!
        return URLRequestBuilder(url: url)
            .setHTTPMethod(.get)
            .setJSONContent()
            .build()
    }
}
