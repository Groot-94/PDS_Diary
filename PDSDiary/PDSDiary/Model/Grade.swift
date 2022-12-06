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
    
    var score: Double {
        switch self {
        case .good:
            return 3.0
        case .soso:
            return 2.0
        case .bad:
            return 1.0
        case .none: 
            return 0.0
        }
    }
}
