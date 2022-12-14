//
//  UIResponder+Extension.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/14.
//

import UIKit

extension UIResponder {
    private weak static var currentFirstResponder: UIResponder? = nil
    
    public static var currentResponder: UIResponder? {
        UIResponder.currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return UIResponder.currentFirstResponder
    }
    
    @objc internal func findFirstResponder(sender: AnyObject) {
        UIResponder.currentFirstResponder = self
    }
}
