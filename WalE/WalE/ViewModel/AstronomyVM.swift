//
//  AstronomyVM.swift
//  Reddit
//
//  Created by Pooja Soni on 25/04/22.
//

import Foundation
import Network


class AstronomyViewModel {
    
    private var networkService: NetworkServiceProtocol
    let defaults = UserDefaults.standard
    
    var astronomy: Astronomy?
    var currentDate: Date = Date()
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchPost(completion: @escaping (_ error: String?) -> Void) {
        networkService.execute(endpoint: .astronomy) {[weak self] result in
            guard let self = self
            else { return }
            
            switch result {
            case .success(let response):
                print(response)
                self.astronomy = response
                self.saveResponse()
                completion(nil)
            case .failure:
                print("error!!!!")
                // Localised
                completion("Failed to fetch data")
            }
        }
    }
    
    //Using USerDefault as the data to save is very little so choose to store the data in ISerDefaults, as there are variuos ways to save the data
    func saveResponse() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.astronomy) {
            defaults.set(encoded, forKey: "astronomy")
        }
    }
    
    func getSavedResponse(completion: @escaping (_ error: String?) -> Void) {
        if let savedNasaDetails = defaults.object(forKey: "astronomy") as? Data {
            let decoder = JSONDecoder()
            if let savedResponse = try? decoder.decode(Astronomy.self, from: savedNasaDetails) {
                //do the needful
                self.astronomy = savedResponse
                completion(nil)
            }
        }
    }
    
    
    func isNetworkReachable(completion: @escaping (_ isSuccess: Bool) -> Void){
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                completion(true)
            }else {
                completion(false)
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
    //to check whether the user is entering for the first time a day 
    func isUserEnteredFirstTimeForTheDay() -> Bool {
        var isFirstTimeUser: Bool = false
        if let currentDate = defaults.object(forKey: "currentDate") as? Date {
            if Calendar.current.compare(Date(), to: currentDate, toGranularity: .day) != .orderedSame{
                isFirstTimeUser = true
                defaults.setValue(Date(), forKey: "currentDate")
            }else {
                isFirstTimeUser = false
            }
        }else {
            defaults.setValue(Date(), forKey: "currentDate")
            isFirstTimeUser = true
        }
        return isFirstTimeUser
    }
}
