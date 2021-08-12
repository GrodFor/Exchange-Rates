//
//  ApiModels.swift
//  Exchange Rates
//
//  Created by Vladislav Sitsko on 12.08.21.
//

import Foundation

// MARK: - Rates
struct Rates: Codable {
    let code: Int
    let messageTitle, message, rid, downloadDate: String
    let rates: [Rate]
    let productState: Int
    let ratesDate: String
}

// MARK: - Rate
struct Rate: Codable {
    let tp: Int
    let name: String
    let currMnemFrom: String
    let from, to: Int
    let currMnemTo, basic, buy, sale: String
    let deltaBuy, deltaSale: String
}
