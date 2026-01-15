import SwiftUI

struct CharactersListView: View {
    @StateObject private var viewModel = CharactersListViewModel()
    
    var contentState: some View {
        List {
            ForEach(Array(viewModel.characters.enumerated()), id: \.element.id) { index, item in
                listItem(item, index: index)
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    func listItem(_ item: Character, index: Int) -> some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: item.image)) { result in
                    result.image?
                        .resizable()
                        .scaledToFill()
                }
                    .frame(width: 30, height: 30)
                Text(item.name)
                    .onAppear {
                        viewModel.fetchNextPageIfNeeded(itemIndex: index)
                    }
            }
            
            Text("\(item.status.rawValue) - \(item.species)")
        }
    }
    
    var errorState: some View {
        VStack {
            Text("Some error occurred")
            Button("Retry") {
                viewModel.fetchCharacters()
            }
        }
    }
    
    var emptyState: some View {
        VStack {
            Text("No results found")
        }
    }
     
    var filterStatusToolbarContent: some View {
        Menu {
            Button("\(viewModel.filterStatus == nil ? "- " : "")All") {
                viewModel.filterStatus = nil
            }
            
            ForEach(Character.Status.allCases, id: \.self) { statusItem in
                Button("\(viewModel.filterStatus == statusItem ? "- " : "")\(statusItem.displayValue)") {
                    viewModel.filterStatus = statusItem
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .content:
                    contentState
                    
                case .error:
                    errorState
                    
                case .empty:
                    emptyState
                }
            }
            .navigationTitle("Rick and Morty")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    filterStatusToolbarContent
                }
            }
            .searchable(text: $viewModel.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search characters")
            .onAppear {
                viewModel.fetchCharacters()
            }
        }
    }
}

#Preview {
    CharactersListView()
}
