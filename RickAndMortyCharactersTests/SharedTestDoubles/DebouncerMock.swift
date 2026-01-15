import Foundation
@testable import RickAndMortyCharacters

final class DebouncerMock: Debouncing {
    private(set) var debounceInvocations: [(queue: DispatchQueue, delay: TimeInterval, code: () -> Void)] = []
    func debounce(queue: DispatchQueue, delay: TimeInterval, _ code: @escaping () -> Void) {
        debounceInvocations.append((queue, delay, code))
    }
    
    func executeLast() {
        debounceInvocations.last?.code()
        debounceInvocations = []
    }
}
