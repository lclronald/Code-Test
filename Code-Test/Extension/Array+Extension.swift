//
//  Array+Extension.swift
//  Code_Test
//
//  Created by Cheuk Long on 3/11/2022.
//

import Foundation
extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}

extension Array where Element: Equatable {
    mutating func appendIfUnique(object: Element) {
        guard !self.contains(object) else { return }
        append(object)
    }
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
}
