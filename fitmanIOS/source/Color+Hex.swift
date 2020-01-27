//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}
extension SwiftUI.Color {
    var redComponent: Double? {
        let val = description
        guard description.hasPrefix("#") else { return nil }
        let r1 = val.index(val.startIndex, offsetBy: 1)
        let r2 = val.index(val.startIndex, offsetBy: 2)
        return Double(Int(val[r1...r2], radix: 16)!) / 255.0
    }

    var greenComponent: Double? {
        let val = description
        guard description.hasPrefix("#") else { return nil }
        let g1 = val.index(val.startIndex, offsetBy: 3)
        let g2 = val.index(val.startIndex, offsetBy: 4)
        return Double(Int(val[g1...g2], radix: 16)!) / 255.0
    }

    var blueComponent: Double? {
        let val = description
        guard description.hasPrefix("#") else { return nil }
        let b1 = val.index(val.startIndex, offsetBy: 5)
        let b2 = val.index(val.startIndex, offsetBy: 6)
        return Double(Int(val[b1...b2], radix: 16)!) / 255.0
    }

    var opacityComponent: Double? {
        let val = description
        guard description.hasPrefix("#") else { return nil }
        let b1 = val.index(val.startIndex, offsetBy: 7)
        let b2 = val.index(val.startIndex, offsetBy: 8)
        return Double(Int(val[b1...b2], radix: 16)!) / 255.0
    }
}
