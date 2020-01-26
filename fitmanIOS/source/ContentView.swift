//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

let flag = true

struct OldContentView: View {
    
    var controller: ExerciseController
    let sessionLabels: [String]
    
    @ObservedObject var state: SessionViewModel
    @State var playPauseLabel: String = "Play"
    @State var selectedExerciseSet = 0
    
    var body: some View {
        return   VStack(alignment: HorizontalAlignment.center, spacing: 0) {
            NavigationView {
                Form {
                    SessionPicker(controller: self.controller, exLabels: sessionLabels, selectedExerciseSet: $selectedExerciseSet)
                    ControlButtons(state: state, playPauseLabel: playPauseLabel)
                    if (flag) {
                        CurrentPrevNextView(session: self.state, current: self.state.currentExerciseIndex)
                    }
                }.navigationBarTitle(Text("Fitman"))
            }
            VStack(alignment: .center) {
                        ProgressCircle(session: self.state)
                        if (!flag) {
                            CurrentPrevNextView(session: self.state, current: self.state.currentExerciseIndex)
                        }
            }.background(Color(.sRGB, white: 0.8, opacity: 1))

        }//.background(Color(.sRGB, white: 0.8, opacity: 1))
    }
}
struct MyTabbedView: View {

var body: some View {
        TabView {
            HomeView().tabItem {
                VStack {
                    Image(systemName: "1.circle")
                    Text("Home")
                }
            }.tag(1)
            AboutView().tabItem {
                VStack {
                    Image(systemName: "2.circle")
                    Text("About")
                }
            }.tag(2)
        }
    }
}
struct AboutView: View {
var body: some View {
    ZStack {
        Color.blue
            .edgesIgnoringSafeArea(.all)
        Text("About View")
            .font(.largeTitle)
    }
}
}
struct HomeView: View {
    var body: some View {
        ZStack {
            Color.red
            .edgesIgnoringSafeArea(.all)
            Text("Home View")
                .font(.largeTitle)
        }
    }
}

struct ContentView: View {

var controller: ExerciseController
let sessionLabels: [String]

@ObservedObject var state: SessionViewModel
@State var playPauseLabel: String = "Play"
@State var selectedExerciseSet = 0

var body: some View {
    TabView {
        RunView(state: state, playPauseLabel: playPauseLabel).tabItem {
            VStack {
                Image(systemName: "1.circle")
                Text("Run")
            }
        }.tag(1)
        SelectView(controller: controller, sessionLabels: sessionLabels, selectedExerciseSet: $selectedExerciseSet).tabItem {
            VStack {
                Image(systemName: "2.circle")
                Text("Select")
            }
        }.tag(2)
    }
}
}
struct RunView: View {
    @ObservedObject var state: SessionViewModel
    @State var playPauseLabel: String = "Play"

    var body: some View {

        VStack(alignment: HorizontalAlignment.center, spacing: 0) {
            ControlButtons(state: state, playPauseLabel: playPauseLabel)
            CurrentPrevNextView(session: self.state, current: self.state.currentExerciseIndex)
            VStack(alignment: .center) {
            ProgressCircle(session: self.state)
            }.background(Color(.sRGB, white: 0.8, opacity: 1))
        }
    }
}

struct SelectView: View {
    
    var controller: ExerciseController
    let sessionLabels: [String]
    @Binding var selectedExerciseSet: Int
    
    var body: some View {
        return   VStack(alignment: HorizontalAlignment.center, spacing: 0) {
            SessionPicker(controller: self.controller, exLabels: sessionLabels, selectedExerciseSet: $selectedExerciseSet)
        }.background(Color(.sRGB, white: 0.8, opacity: 1))
    }
}

//
// picks the exercise session to run.
// Made into a separate View so that it is not updated by progress reporting
//
struct SessionPicker: View {

    var controller: ExerciseController
    var exLabels: [String]
    @Binding var selectedExerciseSet: Int

    var body: some View {
        VStack() {
            Text("Select Exercise Set")
            Picker(selection: $selectedExerciseSet, label: Text("Select your exercises")) {
                ForEach(0 ..< exLabels.count) {
                   Text(self.exLabels[$0]).tag($0)
                }
            }
            .onReceive([self.selectedExerciseSet].publisher.first()) { (value) in
                print("onReceive selected value \(value)")
                self.controller.changeSession(value: value)
            }
            .labelsHidden()
        }
    }
}

struct ControlButtons: View {
    @ObservedObject var state: SessionViewModel
    @State var playPauseLabel: String = "Play"

    var body: some View {
        return HStack(alignment: .center, spacing: 20) {
            Button(action: {
                self.state.previous()
            }) {
                Text("Previous")
            }
            Button(action: {
                self.state.togglePause()
            }) {
                    Text(self.state.buttonLabel)
            }
            Button(action: {
                self.state.next()
            }) {
                Text("Next")
            }
        }
    }
}

struct ProgressBar: View {

    @ObservedObject var session: SessionViewModel
    
    var body: some View {
//        var pdone: Double = self.state.elapsed / self.state.duration
//        print("elapsed:: \($state.elapsed) duration::  \(self.state.duration)")
        return Slider(value: $session.elapsed, in: 0.0...self.session.duration)
    }
}

struct ProgressCircle: View {

    @ObservedObject var session: SessionViewModel

    var body: some View {

        let width: CGFloat = (flag) ? 150.0 : 20.0
        let frameWidth: CGFloat = (flag) ? 150.0 : 600.0
        
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
                    .stroke(Color.gray , lineWidth: width)
                    .frame(width: frameWidth)
                    .rotationEffect(Angle(degrees:-90.0))
                Circle()
                    .trim(from: 0.0, to: CGFloat(session.elapsed / session.duration))
                    .stroke(Color.blue, lineWidth: width)
                    .frame(width: frameWidth)
                    .rotationEffect(Angle(degrees:-90.0))
            }.background(Color(.sRGB, white: 1.0, opacity: 1))
    }
}

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct CurrentPrevNextView: View {
    @ObservedObject var session: SessionViewModel
    var current: Int
    
    var body: some View {
    
//        let prev = session.exercises[safe: current-1]
        let curr = session.exercises[safe: current]
        let next = session.exercises[safe: current+1]
        
        return VStack(alignment: .center, spacing: 20) {
//            Row(exercise: prev, isCurrent: false)
            Row(exercise: curr, isCurrent: true)
            Row(exercise: next, isCurrent: false)
        }
    }
}

struct SessionView: View {

    @ObservedObject var session: SessionViewModel
    var current: Int
    
    var body: some View {
//        List(session.exercises) { exercise in
//            Row(excercise: exercise, currentIndex: self.session.currentExerciseIndex)
//        }
        List {
            ForEach(0 ..< session.exercises.count) { index -> Row in
//                let isCurrent = self.session.currentExerciseIndex == index
                let isCurrent = self.current == index
                return Row(exercise: self.session.exercises[index], isCurrent: isCurrent)
                
            }
        }
    }
    
}

struct Row: View {
    var exercise: Exercise?
    var isCurrent: Bool

    var body: some View {
        let fontSize: CGFloat = !isCurrent ? 20 : 30
        let fontColor: Color = !isCurrent ? Color.black : Color.black
        let labelStr: String = (exercise != nil) ? exercise!.label : " "
        
        return HStack(alignment: .center, spacing: 10) {
            Text("\(labelStr)")
                .font(.custom("Futura", size: fontSize))
                .foregroundColor(fontColor)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let exerciseController = ExerciseController()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(
            controller: exerciseController,
            sessionLabels: exerciseController.exLabels,
            state: exerciseController.model
        )
        
        return contentView
    }
}

