import Foundation

protocol Debouncing {
    func debounce(queue: DispatchQueue, delay: TimeInterval, _ code: @escaping () -> Void)
}

extension Debouncing {
    func debounce(_ code: @escaping () -> Void) {
        debounce(queue: .main, delay: 0.4, code)
    }
}

final class Debouncer {
    private var workItem = DispatchWorkItem {}
}

extension Debouncer: Debouncing {
    func debounce(queue: DispatchQueue, delay: TimeInterval, _ code: @escaping () -> Void) {
        workItem.cancel()
        workItem = DispatchWorkItem(block: code)
        queue.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
}
