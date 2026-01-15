struct CharactersListSearchParams {
    let page: Int
    let name: String?
    let status: Character.Status?
    
    init(page: Int = 0, name: String? = nil, status: Character.Status? = nil) {
        self.page = page
        self.name = name
        self.status = status
    }
}
