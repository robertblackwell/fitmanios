//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI


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
