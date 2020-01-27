import SwiftUI
import AVFoundation

//let speaker: Speaker = Speaker()
func playStart(elapsed: Double) {
    let speaker: Speaker = Speaker()
    speaker.say("This is a long announcement describing an exercise toes and no toes")
    Trace.writeln("play start sound at \(elapsed)")
}
func playText(elapsed: Double) {
    let speaker: Speaker = Speaker()
    speaker.say("This is a long announcement describing an exercise toes and no toes")
    Trace.writeln("play start sound at \(elapsed)")
}

func playPop(elapsed: Double) {
    let speaker: Speaker = Speaker()
    speaker.playPopSound()
    Trace.writeln("play chime sound at \(elapsed)")
}
func playTink(elapsed: Double) {
    let speaker: Speaker = Speaker()
    speaker.playTinkSound()
    Trace.writeln("play chime sound at \(elapsed)")
}
func playPurr(elapsed: Double) {
    let speaker: Speaker = Speaker()
    speaker.playPurrSound()
    Trace.writeln("play chime sound at \(elapsed)")
}

func playProgress(elapsed: Double) {
    Trace.writeln("speak progress at \(elapsed)")
}

func playEnd(elapsed: Double) {
    let speaker: Speaker = Speaker()
    speaker.playPurrSound()
    Trace.writeln("play end at \(elapsed)")
}

func playEndSound(elapsed: Double) {
    let speaker: Speaker = Speaker()
    speaker.playPurrSound()
    Trace.writeln("play end sound at \(elapsed)")
}

func playProgressAnnoucement(text: String)-> ((Double)->Void) {
    return { (elapsed: Double) -> Void in
        let speaker: Speaker = Speaker()
        speaker.say(text)
    }
}
func playText(text: String)-> ((Double)->Void) {
    return { (elapsed: Double) -> Void in
        let speaker: Speaker = Speaker()
        speaker.say(text)
    }
}

func onProgress(elapsed: Double) {
    Trace.writeln("progress at \(elapsed)")
}

func durationOfTasks(tasks: Array<Task>) -> Double {
    return (tasks.last!.elapsed) + 1.0
}

struct Task {
    var elapsed: Double
    var action: (Double) -> ()
}
func buildTasks(exercise: Exercise) -> Array<Task> {
    var tasks = [Task]()
    let announcementDelay: Double = 0.0
    let delay = Defaults.shared().preludeDelay
    let preludeDelay: Double = Double(delay) //10.0
    let exerciseStartElapsed: Double = announcementDelay + preludeDelay

    tasks.append(Task(elapsed: exerciseStartElapsed - 3.0, action: playPop(elapsed:)))
    tasks.append(Task(elapsed: exerciseStartElapsed - 2.0, action: playPop(elapsed:)))
//    tasks.append(Task(elapsed: exerciseStartElapsed - 1.0, action: playPurr(elapsed:)))
    tasks.append(Task(elapsed: exerciseStartElapsed - 1.0, action: playProgressAnnoucement(text: "Go")))
    for i in 0...exercise.duration - 20 {
        if(i % 10 == 0) {
            let txt: String = "\(10+i)"
            let elapsed: Double = exerciseStartElapsed + 10.0 + Double(i)
            tasks.append(Task(elapsed: elapsed, action: playProgressAnnoucement(text: txt)))
        }
    }
    let tmp = exerciseStartElapsed + Double((exercise.duration - 1))
    tasks.append(Task(elapsed: tmp, action: playProgressAnnoucement(text: "done")))
    var endTime: Double = exerciseStartElapsed + 10.0 * Double((exercise.duration))
    endTime = tasks.last!.elapsed
    tasks.append(Task(elapsed: endTime + 0.95, action: playEndSound(elapsed:)))

    // sort tasks - should be unnecessary
    tasks = tasks.sorted(by: { $0.elapsed < $1.elapsed })
    
    return tasks
}

// Creates a task stack
func buildTasks() -> [Task] {
    var tasks = [Task]()
    tasks.append(Task(elapsed: 0.0, action: playStart(elapsed:)))
    tasks.append(Task(elapsed: 7.0, action: playPop(elapsed:)))
    tasks.append(Task(elapsed: 8.0, action: playPop(elapsed:)))
    tasks.append(Task(elapsed: 9.0, action: playPurr(elapsed:)))
    tasks.append(Task(elapsed: 20.0, action: playProgressAnnoucement(text: "10")))
    tasks.append(Task(elapsed: 30.0, action: playProgressAnnoucement(text: "20")))
    tasks.append(Task(elapsed: 40.0, action: playProgressAnnoucement(text: "30")))
    tasks.append(Task(elapsed: 50.0, action: playProgressAnnoucement(text: "40")))
    tasks.append(Task(elapsed: 60.0, action: playProgressAnnoucement(text: "50")))
    tasks.append(Task(elapsed: 62.0, action: playEndSound(elapsed:)))

    // sort tasks
    tasks = tasks.sorted(by: { $0.elapsed < $1.elapsed })
    return tasks
}
// Executes as many pending tasks scheduled for the elapsed time
func attemptToPerformTask(tasks: [Task], elapsed: Double) -> [Task]{
    
    var mutableTasks = tasks
    Trace.writeln("attemptToPerformTask elapsed: \(elapsed)")
    if (mutableTasks.count > 0 && elapsed > mutableTasks[0].elapsed){
        let nextTask = mutableTasks.removeFirst()
        nextTask.action(nextTask.elapsed)
        
        return attemptToPerformTask(tasks: mutableTasks, elapsed: elapsed)
    }
    return mutableTasks
}
