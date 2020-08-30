//
//  NetworkService.swift
//  Stocks
//
//  Created by Artem  on 30.08.2020.
//  Copyright © 2020 Artem . All rights reserved.
//

import Foundation


class NetworkService {
    
    private let token = "pk_cc2367f4df2d44ae8e60a594f02154b9"
    
    func genericFetch<T: Decodable>(urlString: String, completion: @escaping (T) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                completion(objects)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
        dataTask.resume()
    }
    
    func requestQuote(for symbol: String, completion: @escaping (Stock) -> Void) {
        let urlString = "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(token)"
        genericFetch(urlString: urlString, completion: completion)
    }
    
    func fetchCompanies(completion: @escaping ([Stock]) -> Void) {
        let urlString = "https://cloud.iexapis.com/stable/stock/market/list/mostactive?token=\(token)"
        genericFetch(urlString: urlString, completion: completion)
    }
    
    func fetchImage(for symbol: String, completion: @escaping (StockImage) -> Void) {
        let urlString = "https://cloud.iexapis.com/stable/stock/\(symbol)/logo/quote?token=\(token)"
        genericFetch(urlString: urlString, completion: completion)
    }
    
    
    
    //"https://cloud.iexapis.com/stable/stock/\(symbol)/logo/quote?token=\(token)"
}
