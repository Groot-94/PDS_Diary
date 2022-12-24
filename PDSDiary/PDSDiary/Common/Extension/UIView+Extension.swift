//
//  UIView+Extension.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/14.
//

import UIKit

extension UIView {
    var firstResponder: UIView? {
        return findFirstResponder()
    }
    
    func findFirstResponder() -> UIView?{
        guard !isFirstResponder else { return self }
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
}
