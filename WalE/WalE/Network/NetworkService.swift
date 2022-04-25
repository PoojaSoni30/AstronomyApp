//
//  NetworkService.swift
//
// Created by Pooja Soni on 25/04/22.
//

import Foundation


protocol NetworkServiceProtocol {
    func execute(endpoint: Endpoint, completion: @escaping (Result<Astronomy, NetworkError>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {

    // MARK: -
    // MARK: Properties

    private var task: URLSessionDataTask?

    // MARK: -
    // MARK: Methods
    
    func execute(endpoint: Endpoint, completion: @escaping (Result<Astronomy, NetworkError>) -> Void) {
        guard let url = URL(string: endpoint.path) else {
            completion(.failure(.invalidURL))
            return
        }

        task?.cancel()
        task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.unknownError(error)))
                return
            }

            do {
                let astronomy = try JSONDecoder().decode(Astronomy.self, from: data)
                completion(.success(astronomy))
            } catch {
                completion(.failure(.invalidResponse))
            }
        }

        task?.resume()
    }
}



