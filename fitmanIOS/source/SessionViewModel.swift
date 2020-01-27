import SwiftUI
import AVFoundation
//
// Keeping the paused flag sync'd in the SessionModel and ExerciseRunner is untidy
// need to look at this to figure out how to do it
// https://stackoverflow.com/questions/59036863/add-publisher-behaviour-for-computed-property
//

fileprivate let traceLevel: Int = 2

// The play/pause button should be
//
//  -   displaying "Play" when either an Exercise has not started playing or when an Exercise is Paused
//  -   displaying "Pause" when an Exercise is playing
//
// To capture this have the view model maintain a state variable that has values of the following
// Ennum

enum ViewModelState: String {
    case NotPlaying = "notplaying"
    case Playing = "playing"
    case Paused = "paused"
}
enum PlayPauseLabels: String {
    case Play = "Play"
    case Pause = "Pause"
}

func buttonLabelFromState(state: ViewModelState) -> String {
    var r: String //PlayPauseLabels
    switch (state) {
        case ViewModelState.NotPlaying:
            r = "Play" //PlayPauseLabels.Play
            break
        case ViewModelState.Playing:
            r = "Pause" //PlayPauseLabels.Pause
            break
        case ViewModelState.Paused:
            r = "Play" //PlayPauseLabels.Play
            break
    }
    return r
}

//
// Supervises the playing of the exercises from an ExerciseSession.
//
// Implements the play/next/prev operation for Exercise within an ExerciseSession
// Passes a puase request onto the ExercisePlayer but keeps track of the player pause state
//
// Creates a new instance of an ExercisePlayer for each Exercise in
// an ExerciseSession.
//
// Permits the ExerciseSession to be changed ofter an instance is created.
//
// Also
//
class SessionViewModel: ObservableObject {
    var exercises: ExerciseSession
    var runner: ExercisePlayer
    
    var preludeDelay: Int
    @Published var preludeDelayString: String {
        didSet {
            Defaults.shared().preludeDelayString = self.preludeDelayString
            self.preludeDelay = Defaults.shared().preludeDelay
            // this code is called when the preludeDelayString is changed by the view
//            if let tmp = NumberFormatter().number(from: self.preludeDelayString) {
//                self.preludeDelay = tmp.intValue
//                UserDefaults.standard.set(self.preludeDelay, forKey: UserDefaultKeys.preludeDelay)
//            }
        }
    }

    @Published var currentExerciseIndex: Int
    @Published var duration: Double
    @Published var elapsed: Double
    // The label on the play/pause button
    @Published var buttonLabel: String {
        didSet {
            Trace.writeln(traceLevel: traceLevel, "buttonLabel: \(self.buttonLabel)")
        }
    }
    var buttonState: ViewModelState {
        didSet {
            // this code is called when the view Play/Pause button state is changed by a view
            self.buttonLabel = buttonLabelFromState(state: self.buttonState)
            Trace.writeln("buttonState: \(self.buttonState)")
        }
    }

//    public var onComplete: (()->())?

    init(exercises: ExerciseSession) {

//        let tmp: Int = UserDefaults.standard.integer(forKey: UserDefaultKeys.preludeDelay)
//        if (tmp <= 0) || (tmp >= 100) {
//            self.preludeDelay = 10
//        } else {
//            self.preludeDelay = tmp
//        }
        self.preludeDelay = Defaults.shared().preludeDelay
        self.preludeDelayString = String(self.preludeDelay)
        self.currentExerciseIndex = 0
        self.exercises = exercises
        self.buttonState = ViewModelState.NotPlaying
        self.buttonLabel = buttonLabelFromState(state: self.buttonState)
        self.duration = 100.0
        self.elapsed = 0.0
        self.runner = ExercisePlayer()

    }
    //
    // Start playing the exercise session. Start it in paused or running mode
    // depending on the Bool argument
    //
    func go(paused: Bool = false) {
        self.runner.start( startPaused: paused,
            exercise: exercises[self.currentExerciseIndex],
            timerInterval: 0.02,
            onProgress: onProgress(elapsed: duration:),
            onComplete: onRunnerComplete)
        self.buttonState =  (paused) ? ViewModelState.Paused : ViewModelState.Playing
    }
    //
    // next button pressed - cycle forward in the list of exercises in this exercise set - wrap around and arrive at next exercise paused
    //
    func nextButton() {
        self.runner.stop()
        self.buttonState = ViewModelState.NotPlaying
        self.elapsed = 0.0; self.duration = 100.0
        self.currentExerciseIndex = (self.currentExerciseIndex + 1) % self.exercises.count
        self.go(paused: true)
    }
    //
    // previous button pressed - cycle backwards in the list of exercises in this exercise set - wrap around and arrive at next exercise paused
    //
    func previousButton() {
        self.runner.stop()
        self.buttonState = ViewModelState.NotPlaying
        self.elapsed = 0.0; self.duration = 100.0
        self.currentExerciseIndex = (self.currentExerciseIndex + self.exercises.count - 1) % self.exercises.count
        self.go(paused: true)
    }
    //
    // progress to the next exercise or terminate after the last one. Do not pause
    //
    func next() {
        self.runner.stop()
        self.buttonState = ViewModelState.NotPlaying
        self.elapsed = 0.0; self.duration = 100.0
        if(self.currentExerciseIndex < self.exercises.count - 1) {
            self.currentExerciseIndex += 1
            self.go(paused: false)
        } else {
            Trace.writeln("all exercises complete")
            self.buttonState = ViewModelState.NotPlaying
//            if let cb = self.onComplete {
//                cb()
//            }
        }
    }
    //
    // the play/pause button has been pushed
    //
    func togglePause() {
        switch self.buttonState {
            case ViewModelState.NotPlaying:
                assert(self.buttonLabel == buttonLabelFromState(state: ViewModelState.NotPlaying))
                self.buttonState = ViewModelState.Playing
                self.go(paused: false)
                break
            case ViewModelState.Playing:
                assert(self.buttonLabel == buttonLabelFromState(state: ViewModelState.Playing))
                self.buttonState = ViewModelState.Paused
                self.runner.pause()
                break
            case ViewModelState.Paused:
                assert(self.buttonLabel == buttonLabelFromState(state: ViewModelState.Paused))
                self.buttonState = ViewModelState.Playing
                self.runner.resume()
                break
        }
    }
    
    func onProgress(elapsed: Double, duration: Double) {
        self.elapsed = elapsed
        self.duration = duration
    }
    func onRunnerComplete() {
        self.next()

    }
}
