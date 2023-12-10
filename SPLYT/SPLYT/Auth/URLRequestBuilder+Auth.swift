//
//  URLRequestBuilder+Auth.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/10/23.
//

import Foundation
import Networking

extension URLRequestBuilder {
    func setBearerAuth() -> Self {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return self
    }
}
