//
//  Trace.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/24/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//

import Foundation

class Trace {
    public static var globalLevel: Int = 1
    public static func writeln(_ s: String) {
        #if TRACE
            print(s)
        #endif
    }
    public static func writeln(traceLevel: Int = 0, _ s: String) {
        #if TRACE
            if (traceLevel >= Trace.globalLevel) {
                print(s)
            }
        #endif
    }

}
