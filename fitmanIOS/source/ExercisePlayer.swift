import SwiftUI
import AVFoundation

enum PlayerState: String {
    case announcementRequired = "announcement_required"
    case annoucementPending = "announecement_pending"
    case annoucementDone = "announecement_done"
}
//
// Plays a single Exercise allowing the play to be paused and restarted.
// Creating another instance of this class for each new Exercise
//
class ExercisePlayer: Speaker {
    var isPaused: Bool = false
    var isRunning: Bool = false
    var announcementState = PlayerState.annoucementDone
    var timer: Timer?
    
    public func start(
        startPaused: Bool,
        exercise: Exercise,
        timerInterval: Double,
        onProgress: @escaping ((Double, Double)->()),
        onComplete: @escaping (()->())
    ) {
        self.perform(
            startPaused: startPaused,
            exercise: exercise,
            timerInterval: timerInterval,
            onProgress: onProgress,
            onComplete: onComplete)
    }
    public func stop() {
        if self.isRunning && self.announcementState == PlayerState.annoucementPending {
            self.stopSpeech()
        }
        if let tmp = self.timer {
            tmp.invalidate()
        }
    }
    public func pause() {
        assert(!self.isPaused)
        if (!self.isPaused && self.announcementState == PlayerState.annoucementPending) {
            self.pauseSpeech()
        }
        self.isPaused = true

    }
    public func resume() {
        assert(self.isPaused)
        if (self.isPaused && self.announcementState == PlayerState.annoucementPending) {
//            self.announcementState = PlayerState.announcementRequired
            self.resumeSpeech()
        }
        self.isPaused = false

    }
    override func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            Trace.writeln("speech complete - on main thread \(self.isPaused)")
            if (!self.isPaused && self.announcementState == PlayerState.annoucementPending) {
                self.announcementState = PlayerState.annoucementDone
            }
        }
    }
    private func perform(
        startPaused: Bool,
        exercise: Exercise,
        timerInterval: Double,
        onProgress: @escaping ((Double, Double)->()),
        onComplete: @escaping (()->())
     ) {

        var lastTime = NSDate().timeIntervalSince1970
        var elapsed = 0.0
        var tasks: [Task] = buildTasks(exercise: exercise)
        let duration: Double = durationOfTasks(tasks: tasks)
        self.announcementState = PlayerState.announcementRequired
        self.isRunning = true
        self.isPaused = startPaused
        self.timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) {timer in
            // updating lastTime in each of the following if statements
            // ensures that time stands still while paused or an announcement is happening
            if self.isPaused {
                lastTime = NSDate().timeIntervalSince1970
                return
            }
            if (self.announcementState == PlayerState.announcementRequired) {
                self.announcementState = PlayerState.annoucementPending
                self.announce(exercise)
                lastTime = NSDate().timeIntervalSince1970
                return
            }
            if (self.announcementState == PlayerState.annoucementPending) {
                lastTime = NSDate().timeIntervalSince1970
                return
            }
            let now = NSDate().timeIntervalSince1970
            elapsed = elapsed + (now - lastTime)
            lastTime = now
            // process all elapsed tasks
            while (tasks.count > 0 && elapsed >= tasks[0].elapsed) {
                let t: Task = tasks.removeFirst()
                Trace.writeln("Timer::action elapsed: \(elapsed)  \(t.elapsed)")
                t.action(elapsed)
            }

            onProgress(elapsed, duration)
            // elapsed > duration - all tasks should have elapsed
            if (elapsed > duration) {
                timer.invalidate()
                self.isRunning = false
                onComplete()
            }
        }
    }
}
