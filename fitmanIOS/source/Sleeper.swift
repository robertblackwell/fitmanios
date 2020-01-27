//
//  Controller.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/8/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//
#if os(OSX)
import IOKit.pwr_mgt

var assertionID: IOPMAssertionID = 0
var sleepDisabled = false

func disableScreenSleep(reason: String = "Disabling Screen Sleep") {
    Trace.writeln("PREVENTING SLEEP")
    sleepDisabled =  IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep as CFString, IOPMAssertionLevel(kIOPMAssertionLevelOn), reason as CFString, &assertionID) == kIOReturnSuccess
}
func  enableScreenSleep() {
    Trace.writeln("ALLOWING SLEEP")
    IOPMAssertionRelease(assertionID)
    sleepDisabled = false
}
#else
func disableScreenSleep(reason: String = "Disabling Screen Sleep") {}
func  enableScreenSleep() {}

#endif
