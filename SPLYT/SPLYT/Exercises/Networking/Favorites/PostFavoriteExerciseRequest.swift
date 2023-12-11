//
//  PostFavoriteExerciseRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/11/23.
//

import Foundation
import Networking
import UserAuth

/// Toggles favorite for an exercise for the user
struct PostFavoriteExerciseRequest: NetworkRequest {
    typealias Response = PostFavoriteExerciseResponse
    private let requestBody: PostFavoriteExerciseRequestBody
    private let userAuth: UserAuthType
    
    init(requestBody: PostFavoriteExerciseRequestBody,
         userAuth: UserAuthType = UserAuth()) {
        self.requestBody = requestBody
        self.userAuth = userAuth
    }
    
    func createRequest() async -> URLRequest {
        let url = URL(string: "TODO")!
        return await URLRequestBuilder(url: url, userAuth: userAuth)
            .setHTTPMethod(.post)
            .setJSONContent()
            .setBody(requestBody)
            .setBearerAuth()
            .build()
    }
}

struct PostFavoriteExerciseRequestBody: Codable {
    let exerciseId: String
    let isFavorite: Bool
    
    private enum CodingKeys: String, CodingKey {
        case exerciseId = "exercise_id"
        case isFavorite = "is_favorite"
    }
}

struct PostFavoriteExerciseResponse: Codable {
    let success: Bool
}
