//
//  UpdateFavoriteExerciseRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/11/23.
//

import Foundation
import Networking
import UserAuth

/// Toggles favorite for an exercise for the user.
struct UpdateFavoriteExerciseRequest: NetworkRequest {
    typealias Response = FavoriteExercisesResponse
    private let requestBody: UpdateFavoriteExerciseRequestBody
    private let userAuth: UserAuthType
    
    init(requestBody: UpdateFavoriteExerciseRequestBody,
         userAuth: UserAuthType = UserAuth()) {
        self.requestBody = requestBody
        self.userAuth = userAuth
    }
    
    func createRequest() async throws -> URLRequest {
        guard let url = URL(string: "https://favorites-2iropnvq6q-uc.a.run.app") else {
            throw NetworkError.invalidURL
        }
        
        return await URLRequestBuilder(url: url, userAuth: userAuth)
            .setHTTPMethod(.post)
            .setJSONContent()
            .setBody(requestBody)
            .setBearerAuth()
            .build()
    }
}

struct UpdateFavoriteExerciseRequestBody: Codable {
    let exerciseId: String
    let isFavorite: Bool
}
