//
//  ExcangeRatesViewModel.swift
//  Exchange Rates
//
//  Created by Vladislav Sitsko on 12.08.21.
//

import Foundation

class ExchangeRatesViewModel {
    private(set) var items: [Rate] = []
    
    func fetchItems(completion: @escaping (Result<Void, Error>)->Void) {
        NetworkService.shared.fetchExchangeRates { [weak self] data, _, error in
            if let data = data, let rates = try? JSONDecoder().decode(Rates.self, from: data).rates {
                self?.items = rates
                completion(.success(()))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
