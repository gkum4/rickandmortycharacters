import Foundation

var apiBaseURL: URL = {
    guard let url = URL(string: EnvironmentKeys.rickAndMortyBaseURL.getKey()) else {
        fatalError("apiBaseURL must be a correct URL")
    }
    return url
}()
