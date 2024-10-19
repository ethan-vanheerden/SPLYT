//
//  DeleteAccountRequest.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 10/18/24.
//

import Foundation
import Networking
import UserAuth

struct DeleteAccountRequest: NetworkRequest {
    typealias Response = NoResponse
    private let userAuth: UserAuthType
    
    init(userAuth: UserAuthType = UserAuth()) {
        self.userAuth = userAuth
    }
    
    func createRequest() async throws -> URLRequest {
        guard let url = URL(string: "https://deleteuser-2iropnvq6q-uc.a.run.app") else {
            throw NetworkError.invalidURL
        }
        
        return await URLRequestBuilder(url: url, userAuth: userAuth)
            .setHTTPMethod(.delete)
            .setBearerAuth()
            .build()
    }
}
