//
//  String.swift
//  Phew
//
//  Created by dong eun shin on 5/3/25.
//

import Foundation

extension String {
    func toEmoji() -> String? {
        guard
            let scalar = UInt32(self, radix: 16),
            let unicodeScalar = UnicodeScalar(scalar)
        else {
            return nil
        }
        return String(unicodeScalar)
    }

    func toHexCode() -> [String] {
        return self.unicodeScalars.map { String(format: "%X", $0.value) }
    }
}
