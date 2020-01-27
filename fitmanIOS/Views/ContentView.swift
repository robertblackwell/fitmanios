//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

let flag = true

struct ContentView: View {

    @ObservedObject var controller: ExerciseController
    let sessionLabels: [String]

    @State var playPauseLabel: String = "Play"
    @State var selectedExerciseSet = 0

    var body: some View {
        let jumpingImage = #imageLiteral(resourceName: "jumping")
        return TabView {
            RunView(model: controller.model, sessionKey: controller.selectedSessionKey).tabItem {
                VStack {
                    Image(uiImage: jumpingImage)
                    Text("Perform Exercises").font(.system(size:30)).frame(width:100, height:50)
                }
            }.tag(1)
            SelectView(controller: controller, sessionLabels: sessionLabels, selectedExerciseSet: $controller.selectedSessionIndex).tabItem {
                VStack {
                    Image(systemName: "list.dash")
                    Text("Select Exercises")
                }
            }.tag(2)
        }.accentColor(Color(hex: 0xd4292a))
    }
}
struct RunView: View {
    @ObservedObject var model: SessionViewModel
    var sessionKey: String
    
    var body: some View {

        VStack(alignment: HorizontalAlignment.center, spacing: 0) {
            Spacer()
            Text("\(sessionKey)").font(.system(size:25)).bold().foregroundColor(Color(hex: 0xd4292a))
            Spacer()
            CurrentNextView(session: self.model, current: self.model.currentExerciseIndex)
            VStack(alignment: .center) {
            ProgressCircle(session: self.model)
            Spacer()
            ControlButtons(model: model)
            }//.background(Color(.sRGB, white: 0.8, opacity: 1))
        }
    }
}

struct SelectView: View {

    var controller: ExerciseController
    let sessionLabels: [String]
    @Binding var selectedExerciseSet: Int
    
    var body: some View {
        return   VStack(alignment: HorizontalAlignment.center, spacing: 0) {
            if (controller.model.buttonState == ViewModelState.NotPlaying) {
                SessionPicker(controller: self.controller, exLabels: sessionLabels, selectedExerciseSet: $selectedExerciseSet)
            } else {
                HStack(spacing: 20) {
                    Spacer()
                    VStack(spacing: 30) {
                    Spacer()
                    Text("Cannot change selection while playing or paused").foregroundColor(Color.red).font(.system(size:35))
                    Spacer()
                    Text("Please return to the ").foregroundColor(Color.blue).font(.system(size:25))
                    Text("Perform Exercise").foregroundColor(Color.blue).font(.system(size:30)).bold()
                    Text("screen").foregroundColor(Color.blue).font(.system(size:25))
                    Spacer()
                    }
                    Spacer()
                }.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height).background(Color.black)
            }
        }.background(Color(.sRGB, white: 0.8, opacity: 1))
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let exerciseController = ExerciseController()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(
            controller: exerciseController,
            sessionLabels: exerciseController.exLabels
        )
        
        return contentView
    }
}
