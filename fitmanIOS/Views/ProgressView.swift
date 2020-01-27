//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct ProgressCircle: View {

    @ObservedObject var session: SessionViewModel

    var body: some View {

        let width: CGFloat = (flag) ? 150.0 : 20.0
        let frameWidth: CGFloat = (flag) ? 150.0 : 600.0
        let sweepColor = Color(hex: 0xd4292a)
        let bgColor = Color(hex: 0xf3f5f9)
//        let bgColor = Color.white //NSColor(named: NSColor.Name("progressBarBg"))
//        let barColor = (flag) ? Color.red : Color.blue
//            ? NSColor(named: NSColor.Name("Progressbar"))
//            : NSColor(named: NSColor.Name("exerciseProgressBar"))
//        let barColor = (session.stateMachine?.state != SM_State.prelude)
//            ? NSColor(named: NSColor.Name("exerciseProgressBar"))
//            : NSColor(named: NSColor.Name("countInProgressBar"))
        
        return
            ZStack {
                Circle()
                    .stroke(bgColor , lineWidth: width)
                    .frame(width: frameWidth)
                    .rotationEffect(Angle(degrees:-90.0))
                Circle()
                    .trim(from: 0.0, to: CGFloat(session.elapsed / session.duration))
                    .stroke(sweepColor, lineWidth: width)
                    .frame(width: frameWidth)
                    .rotationEffect(Angle(degrees:-90.0))
            }.background(Color(.sRGB, white: 1.0, opacity: 1))
    }
}

