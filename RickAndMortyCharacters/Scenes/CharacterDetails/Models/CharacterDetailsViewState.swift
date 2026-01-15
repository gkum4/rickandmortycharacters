enum CharacterDetailsViewState: Equatable {
    case content(_ character: Character)
    case loading
    case error
}

extension CharacterDetailsViewState {
    var viewTitle: String {
        switch self {
        case .content(let character):
            return character.name
        case .loading:
            return "Loading"
        case .error:
            return "Error"
        }
    }
}
