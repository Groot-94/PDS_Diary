//
//  Grade.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/06.
//

enum Grade: String {
    case good
    case soso
    case bad
    case none
    
    var score: Int {
        switch self {
        case .good:
            return 0
        case .soso:
            return 1
        case .bad:
            return 2
        case .none: 
            return 3
        }
    }
    
    var emoticon: String {
        switch self {
        case .good:
            return "😆"
        case .soso:
            return "😗"
        case .bad:
            return "😔"
        case .none:
            return "🫥"
        }
    }
}
