//
//  Collection+SafeIndex.swift
//  Exchange Rates
//
//  Created by Vladislav Sitsko on 12.08.21.
//

import Foundation

extension Collection where Indices.Iterator.Element: Equatable, Index == Indices.Iterator.Element {
    subscript (safe index: Indices.Iterator.Element) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
