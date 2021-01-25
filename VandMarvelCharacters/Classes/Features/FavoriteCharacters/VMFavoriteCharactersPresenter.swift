// Created on 25/01/21. 

public protocol VMFavoriteCharactersViewToPresenter {

    func reloadCharacters()
    func showEmptyState(withMessage message: String)

}

public protocol VMFavoriteCharactersInteractorToPresenter {

    func fetchCharacters(withQuery query: String?)

}

public protocol VMFavoriteCharactersRouterToPresenter {

    func openDetails(of character: VMCharacter)

}

public class VMFavoriteCharactersPresenter {

    public init(
        view: VMFavoriteCharactersViewToPresenter,
        interactor: VMFavoriteCharactersInteractorToPresenter,
        router: VMFavoriteCharactersRouterToPresenter
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    private let view: VMFavoriteCharactersViewToPresenter
    private let interactor: VMFavoriteCharactersInteractorToPresenter
    private let router: VMFavoriteCharactersRouterToPresenter

    private var characters: [VMCharacter] = []

    private var currentQuery: String? {
        didSet {
            if currentQuery != oldValue {
                fetchCharacters()
            }
        }
    }

    private func fetchCharacters() {
        interactor.fetchCharacters(withQuery: currentQuery)
    }

}

extension VMFavoriteCharactersPresenter: VMFavoriteCharactersPresenterToView {

    public func viewWillAppear() {
        interactor.fetchCharacters(withQuery: currentQuery)
    }

    public var numberOfCharacters: Int { characters.count }

    public func filter(withQuery query: String?) {
        currentQuery = query
    }

    public func cancelFilter() {
        currentQuery = nil
    }

    public func character(atRow row: Int) -> VMCharacter {
        characters[row]
    }

    public func didSelectCharacter(atRow row: Int) {
        router.openDetails(of: characters[row])
    }

    public func didUnfavoriteCharacter(atRow row: Int) {
        characters[row].isFavorited = false
        characters.remove(at: row)
    }

}

extension VMFavoriteCharactersPresenter: VMFavoriteCharactersPresenterToInteractor {

    public func didFetchCharacters(_ characters: [VMCharacter], toQuery query: String?) {
        guard query == currentQuery else { return }

        self.characters = characters
        view.reloadCharacters()
    }

}
