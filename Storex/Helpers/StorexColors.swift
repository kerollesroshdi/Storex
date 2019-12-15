//
//  StorexColors.swift
//  Storex
//
//  Created by admin on 12/15/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

typealias rgbColor = (red: Float, green: Float, blue: Float)

enum StorexColor: String {
    case White
    case Black
    case Red
    case Orange
    case Yellow
    case Green
    case Blue
    case Indigo
    case Purple
    
    var rgbColor: rgbColor {
        switch self {
        case .White:
            return (240, 240, 240)
        case .Black:
            return (0, 0, 0)
        case .Red:
            return (219, 35, 35)
        case .Orange:
            return (219, 90, 35)
        case .Yellow:
            return (219, 200, 35)
        case .Green:
            return (35, 219, 109)
        case .Blue:
            return (35, 120, 219)
        case .Indigo:
            return (72, 35, 219)
        case .Purple:
            return (204, 35, 219)
        }
    }
}


