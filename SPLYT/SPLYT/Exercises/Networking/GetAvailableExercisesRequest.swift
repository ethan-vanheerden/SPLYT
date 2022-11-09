//
//  GetAvailableExercisesRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/13/22.
//

import Foundation
import Networking

/// Gets a list of all of the exercises that the user is able to do.
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
