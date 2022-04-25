//
//  Endpoints.swift
//
//  Created by Pooja Soni on 24/04/22.
//

import Foundation
enum Endpoint {

    /// Fetches details from astronomy url.
    case astronomy
}

// MARK: -
// MARK: Queries
extension Endpoint {

    /// The path for the specific endpoint.
    var path: String {
        switch self {
        case .astronomy:
            return "https://api.nasa.gov/planetary/apod?api_key=Ee9Ve0GNUal7E8f09sdjUpJUfedKJs7EvwW11uxy"
        }
    }

}
