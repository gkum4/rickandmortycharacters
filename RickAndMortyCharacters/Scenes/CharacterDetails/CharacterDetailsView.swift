import SwiftUI

struct CharacterDetailsView: View {
    @StateObject private var viewModel: CharacterDetailsViewModel
    
    init(id: Int) {
        self._viewModel = StateObject(wrappedValue: CharacterDetailsViewModel(id: id))
    }
    
    func contentState(_ character: Character) -> some View {
        VStack {
            AsyncImage(url: URL(string: character.image))
            Text("Name: \(character.name)")
            Text("\(character.status.rawValue) - \(character.species) - \(character.gender.rawValue)")
            Text("Origin: \(character.origin.name)")
            Text("Location: \(character.location.name)")
            Text("Episode count: \(character.episode.count)")
        }
    }
    
    var loadingState: some View {
        ProgressView()
            .frame(maxWidth: .infinity)
    }
    
    var errorState: some View {
        VStack {
            Text("Some error occurred")
            Button("Retry") {
                viewModel.fetchCharacter()
            }
        }
    }
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .content(let character):
                contentState(character)
            case .loading:
                loadingState
            case .error:
                errorState
            }
        }
        .navigationTitle(viewModel.viewState.viewTitle)
        .onAppear {
            viewModel.fetchCharacter()
        }
    }
}
