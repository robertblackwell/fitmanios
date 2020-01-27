//
//  Error.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/8/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//

import Foundation

struct FitmanError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}

func exerciseErrorDialog(text: String) {
    #if os(OSX)
    let alert = NSAlert()
    alert.messageText = "Error: "
    alert.informativeText = text
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
    #else
        print("error \(text)")
    #endif
}

func fred() {
    exerciseErrorDialog(text: "This is from fred")
}
