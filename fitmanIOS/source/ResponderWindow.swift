//
//  ResponderWindow.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/9/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//
#if os(OSX)
import Cocoa

// We subclass an NSView

class ResponderWindow: NSWindow {
    public var model: SessionViewModel?
    // Allow view to receive keypress (remove the purr sound)
    override var acceptsFirstResponder : Bool {
        return true
    }

    // Override the NSView keydown func to read keycode of pressed key
    override func keyDown(with theEvent: NSEvent) {
        Trace.writeln("keycode: \(theEvent.keyCode)")
        
        switch theEvent.keyCode {
            case 49: //space
                // TODO
                if let m = self.model {
                    m.togglePause()
                }
                Trace.writeln("key space")
                return
            case 123: //left
                // TODO
                if let m = self.model {
                    m.previousButton()
                }
                Trace.writeln("key left")
                return
            case 124: //right
                // TODO
                if let m = self.model {
                    m.nextButton()
                }
                Trace.writeln("key right")
                return
            default:
                return
        }
    }
}
#endif
