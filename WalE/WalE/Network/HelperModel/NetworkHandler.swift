//
//  NetworkError.swift
//
//  Created by Pooja Soni on 24/04/22.
//

import Foundation
import Network

enum NetworkError: Error {
    /// The URL was invalid.
    case invalidURL

    /// The response was invalid and JSON parsing failed.
    case invalidResponse

    /// An error occurred but the exact reason is unknown or unvaluable.
    case unknownError(Error?)
}
