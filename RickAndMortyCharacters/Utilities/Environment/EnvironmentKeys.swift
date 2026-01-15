import Foundation

enum EnvironmentKeys: String {
    case rickAndMortyBaseURL = "RICKANDMORTY_BASE_URL"
}

extension EnvironmentKeys {
    func getKey() -> String {
        guard let value = ProcessInfo.processInfo.environment[self.rawValue] else {
            fatalError("\(self.rawValue) should be defined as a Environment Variable")
        }
        
        return value
    }
}
