//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

fileprivate func buttonHeight() -> CGFloat {
    return 75.0
}
fileprivate func buttonWidth() -> CGFloat {
    return (UIScreen.main.bounds.size.width - 0.0) / 3.0
}
fileprivate struct ControlDivider: View {
    var body: some View {
        Divider().frame(height: buttonHeight()).background(Color(hex: 0xd4292a))
    }
}
fileprivate struct ControlButton: View {
    var label: String
    var action: (()->())
    
    var body: some View {
    
        let width: CGFloat = buttonWidth()
        let height: CGFloat = buttonHeight()
        let bg: Double = 0.8
        let bgC = Color(hex: 0xf3f5f9)
            return Button(action: {
                self.action()
                }) {
                Text(label)
                    .bold()
                    .frame(width: width, height: height)
                    .background(bgC)
                    //.background(Color(.sRGB, white: bg, opacity: 1))
            }
    }
}

struct ControlButtons: View {

    @ObservedObject var model: SessionViewModel

    var body: some View {

        return HStack(alignment: VerticalAlignment.center, spacing: 0) {

            ControlButton(label: "Prev"){
                self.model.previousButton()
            }
            ControlDivider()
            ControlButton(label: self.model.buttonLabel){
                self.model.togglePause()
            }
            ControlDivider()
            ControlButton(label: "Next"){
                self.model.nextButton()
            }
        }
    }
}

