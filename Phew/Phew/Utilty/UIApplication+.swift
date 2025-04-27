//
//  UIApplication+.swift
//  Phew
//
//  Created by dong eun shin on 4/27/25.
//

import UIKit

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
