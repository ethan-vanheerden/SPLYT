//
//  CreateCustomExerciseRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/22/24.
//

import Foundation
import Networking
import UserAuth
import ExerciseCore

struct CreateCustomExerciseRequest: NetworkRequest {
    typealias Response = AvailableExercise
    private let requestBody: CreateCustomExerciseRequestBody
    private let userAuth: UserAuthType
    
    init(requestBody: CreateCustomExerciseRequestBody,
         userAuth: UserAuthType = UserAuth()) {
        self.requestBody = requestBody
        self.userAuth = userAuth
    }
    
    func createRequest() async throws -> URLRequest {
        guard let url = URL(string: "https://customexercises-2iropnvq6q-uc.a.run.app") else {
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

struct CreateCustomExerciseRequestBody: Codable {
    let name: String
    let musclesWorked: [MusclesWorked]
}
