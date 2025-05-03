//
//  Double+.swift
//  Phew
//
//  Created by dong eun shin on 5/2/25.
//

import Foundation

extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
