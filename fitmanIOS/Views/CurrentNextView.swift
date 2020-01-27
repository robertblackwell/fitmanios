//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct CurrentNextView: View {
    @ObservedObject var session: SessionViewModel
    var current: Int
    
    var body: some View {
    
//        let prev = session.exercises[safe: current-1]
        let curr = session.exercises[safe: current]
        let next = session.exercises[safe: current+1]
        
        return VStack(alignment: .center, spacing: 10) {
//            Row(exercise: prev, isCurrent: false)
            Row(exercise: curr, isCurrent: true)
            Row(exercise: next, isCurrent: false)
        }
    }
}

struct Row: View {
    var exercise: Exercise?
    var isCurrent: Bool

    var body: some View {
        let fontSize: CGFloat = !isCurrent ? 20 : 25
        let fontColor: Color = !isCurrent ? Color.black : Color.black
        let labelStr: String = (exercise != nil) ? exercise!.label : " "
        
        return HStack(alignment: .center, spacing: 10) {
            Text("\(labelStr)")
                .font(.custom("Futura", size: fontSize))
                .foregroundColor(fontColor)
        }
    }
}
