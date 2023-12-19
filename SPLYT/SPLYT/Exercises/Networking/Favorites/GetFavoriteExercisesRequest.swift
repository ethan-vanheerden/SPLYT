//
//  GetFavoriteExercisesRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/11/23.
//

import Foundation
import ExerciseCore
import Networking
import UserAuth

/// Gets the exercise IDs that the user has favorited.
struct GetFavoriteExercisesRequest: NetworkRequest {
    typealias Response = FavoriteExercisesResponse
    private let userAuth: UserAuthType
    
    init(userAuth: UserAuthType = UserAuth()) {
        self.userAuth = userAuth
    }
    
    func createRequest() async -> URLRequest {
        let url = URL(string: "https://favorites-2iropnvq6q-uc.a.run.app")!
        return await URLRequestBuilder(url: url, userAuth: userAuth)
            .setHTTPMethod(.get)
            .setJSONContent()
            .setBearerAuth()
            .build()
    }
}

struct FavoriteExercisesResponse: Codable {
    let userFavorites: [String]
}
