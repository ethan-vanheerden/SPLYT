//
//  GetAvailableExercisesRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 8/13/22.
//

import Foundation
import Networking
import ExerciseCore
import UserAuth

/// Gets a list of all of the exercises that the user is able to do.
struct GetAvailableExercisesRequest: NetworkRequest {
    typealias Response = GetAvailableExercisesResponse
    private let userAuth: UserAuthType
    
    init(userAuth: UserAuthType = UserAuth()) {
        self.userAuth = userAuth
    }
    
    func createRequest() async throws -> URLRequest {
        guard let url = URL(string: "https://exercises-2iropnvq6q-uc.a.run.app") else {
            throw NetworkError.invalidURL
        }
        
        return await URLRequestBuilder(url: url, userAuth: userAuth)
            .setHTTPMethod(.get)
            .setJSONContent()
            .setBearerAuth()
            .build()
    }
}

struct GetAvailableExercisesResponse: Codable {
    let exercises: [AvailableExercise]
}
