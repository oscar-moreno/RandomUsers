import Foundation

final class Debouncer: NSObject {
    private let callback: (() -> Void)
    private let delay: Double
    private weak var timer: Timer?

    init(delay: Double, callback: @escaping (() -> Void)) {
        self.delay = delay
        self.callback = callback
    }

    func call() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: delay,
                                             target: self,
                                             selector: #selector(Debouncer.fireNow),
                                             userInfo: nil,
                                             repeats: false)
        timer = nextTimer
    }

    @objc func fireNow() {
        self.callback()
    }
}
