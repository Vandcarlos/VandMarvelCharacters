// Created on 21/01/21. 

import VandMarvelAPI

public protocol VMListCharactersViewToPresenter {

    func reloadCharacters()
    func showErrorAlert(withTitle title: String, withMessage message: String)

}

public protocol VMListCharactersInteractorToPresenter {

    func fetchCharacters(withQuery query: String?, maxResults: Int)

}

public protocol VMListCharactersRouterToPresenter {

}

public class VMListCharactersPresenter {

    public init(
        view: VMListCharactersViewToPresenter,
        interactor: VMListCharactersInteractorToPresenter,
        router: VMListCharactersRouterToPresenter
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    private let view: VMListCharactersViewToPresenter
    private let interactor: VMListCharactersInteractorToPresenter
    private let router: VMListCharactersRouterToPresenter

    private let loadMoreCharactersWhenLeft = 10
    private let numberOfFakeCharacters = 10
    private let maxOfCharactersPerPageOnFetch = 10

    private var fetchedChracters: [VMCharacter] = [] {
        didSet {
            updateFilteredCharacters()
        }
    }

    private var filteredCharacters: [VMCharacter] = [] {
        didSet {
            view.reloadCharacters()
        }
    }

    private var currentQuery: String? {
        didSet {
            updateFilteredCharacters()
        }
    }

    private var performingRequest: Bool = false
    private var allCharactersFetched: Bool = false

    private func updateFilteredCharacters() {
        if let query = currentQuery {
            filteredCharacters = fetchedChracters.filter { $0.name.contains(query) }
        } else {
            filteredCharacters = fetchedChracters
        }
    }

    public func fetchMoreCharacters() {
        guard !performingRequest, !allCharactersFetched else { return }
        performingRequest = true

        interactor.fetchCharacters(withQuery: currentQuery, maxResults: maxOfCharactersPerPageOnFetch)
    }

}

extension VMListCharactersPresenter: VMListCharactersPresenterToView {

    public var numberOfCharacters: Int {
        allCharactersFetched ? filteredCharacters.count : filteredCharacters.count + numberOfFakeCharacters
    }

    public func viewDidAppear() {
        fetchMoreCharacters()
    }

    public func filter(withQuery query: String?) {
        currentQuery = query
    }

    public func cancelFilter() {
        currentQuery = nil
    }

    public func character(atRow row: Int) -> VMCharacter? {
        if row >= filteredCharacters.count - loadMoreCharactersWhenLeft {
            fetchMoreCharacters()
        }

        return filteredCharacters[unsafeIndex: row]
    }

}

extension VMListCharactersPresenter: VMListCharactersPresenterToInteractor {

    public func didFetchCharacters(_ characters: [VMCharacter]) {
        allCharactersFetched = characters.count < maxOfCharactersPerPageOnFetch
        fetchedChracters.append(contentsOf: characters)
        performingRequest = false
    }

    public func didFailOnFetchCharacters(with error: Error) {
        var message: String = VandMarvelCharacters.shared.charactersMessages.alertMessage

        if let error = error as? VMError, error == .noInternet {
            message = VandMarvelCharacters.shared.charactersMessages.withoutInternetConnection
        }

        let title = VandMarvelCharacters.shared.charactersMessages.alertTitle

        view.showErrorAlert(withTitle: title, withMessage: message)
        performingRequest = false
    }

}

fileprivate extension Array where Element == VMCharacter {

    subscript(unsafeIndex unsafeIndex: Int) -> VMCharacter? {
        unsafeIndex < count  ? self[unsafeIndex] : nil
    }

}
