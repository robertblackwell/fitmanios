//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct LabelItem {
    var label: String;
    var id: Int;
}
fileprivate func mkLabels(exLabels: [String]) -> [LabelItem] {
    var res: [LabelItem] = []
    var ix: Int = 0
    for label in exLabels {
        let itm: LabelItem = LabelItem(label: label, id: ix)
        res.append(itm)
        ix += 1
    }
    return res
}

//
// picks the exercise session to run.
// Made into a separate View so that it is not updated by progress reporting
//
struct SessionPicker: View {

    var controller: ExerciseController
    var exLabels: [String]
    @Binding var selectedExerciseSet: Int
    
    init(controller: ExerciseController, exLabels: [String], selectedExerciseSet: Binding<Int>) {
        self.exLabels = exLabels
        self.controller = controller
        self._selectedExerciseSet = selectedExerciseSet
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(hex: 0xd4292a)]

        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(hex: 0xd4292a)]
    }
    
    var body: some View {
        let ar: [LabelItem] = mkLabels(exLabels: self.exLabels)

        return VStack() {
            NavigationView {
                Form {
                    Picker(selection: $selectedExerciseSet, label: Text("Select your exercises")) {
                        ForEach(ar, id: \.id) { item in
                           Text(item.label).tag(item.id)
                        }
                    }
                    .onReceive([self.selectedExerciseSet].publisher.first()) { (value) in
                        print("onReceive selected value \(value)")
                        //self.controller.changeSession(value: value)
                    }
                    .labelsHidden()
                }
                .navigationBarTitle("Select Exercises")
                .background(NavigationConfigurator { nc in
                    nc.navigationBar.barTintColor = .blue
                    nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.green]
                })
            }
        }
    }
}
struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}
