//
//  AstronomyVM.swift
//  Reddit
//
//  Created by Pooja Soni on 23/04/22.
//

import Foundation
import Network


class AstronomyViewModel {
    
    private var networkService: NetworkServiceProtocol
   
    var astronomy: Astronomy?
    var currentDate: Date = Date()
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchPost(completion: @escaping (_ error: String?) -> Void) {
    }

}
