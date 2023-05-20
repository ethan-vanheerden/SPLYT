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
// TODO: this is not used right now as I am figuring out caching mechanism first
struct GetAvailableExercisesRequest: NetworkRequest {
    typealias Response = [AvailableExercise]
    
    func createRequest() -> URLRequest {
        let url = ServerURL.createURL(path: "/exercises")
        return URLRequestBuilder(url: url)
            .setHTTPMethod(.get)
            .setJSONContent()
            .build()
    }
}
