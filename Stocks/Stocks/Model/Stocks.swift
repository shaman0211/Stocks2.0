//
//  Stocks.swift
//  Stocks
//
//  Created by Artem  on 30.08.2020.
//  Copyright © 2020 Artem . All rights reserved.
//

import Foundation


struct Stock: Decodable {
    var symbol: String
    var companyName: String
    var latestPrice: Double
    var change: Double
}

struct StockImage: Decodable {
    var url: String
}
