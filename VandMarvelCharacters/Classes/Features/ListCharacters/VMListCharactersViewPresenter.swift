// Created on 21/01/21. 

import VandMarvelAPI

public protocol VMListCharactersViewToPresenter {

    func reloadCharacters()
    func showErrorAlert(withTitle title: String, withMessage message: String)
    func showEmptyState(withMessage message: String, showTryAgainButton: Bool)

}

public protocol VMListCharactersInteractorToPresenter {

    func fetchCharacters(withQuery query: String?, limit: Int, offset: Int)

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

    private var characters: [VMCharacter] = []

    private var currentQuery: String? {
        didSet {
            if oldValue != currentQuery {
                characters = []
                performingRequest = false
                allCharactersFetched = false

                view.reloadCharacters()
                fetchMoreCharacters()
            }
        }
    }

    private var performingRequest: Bool = false

    private var allCharactersFetched: Bool = false

    public func fetchMoreCharacters() {
        guard !performingRequest, !allCharactersFetched else { return }

        performingRequest = true

        interactor.fetchCharacters(
            withQuery: currentQuery,
            limit: maxOfCharactersPerPageOnFetch,
            offset: characters.count
        )
    }

}

extension VMListCharactersPresenter: VMListCharactersPresenterToView {

    public var numberOfCharacters: Int {
        allCharactersFetched ? characters.count : characters.count + numberOfFakeCharacters
    }

    public func viewDidAppear() {
        view.reloadCharacters()

        if characters.isEmpty {
            allCharactersFetched = false
            fetchMoreCharacters()
        }
    }

    public func filter(withQuery query: String?) {
        currentQuery = query
    }

    public func cancelFilter() {
        currentQuery = nil
    }

    public func character(atRow row: Int) -> VMCharacter? {
        if row >= characters.count - loadMoreCharactersWhenLeft {
            fetchMoreCharacters()
        }

        return characters[unsafeIndex: row]
    }

    public func tryAgainDidTap() {
        fetchMoreCharacters()
        view.reloadCharacters()
    }

}

extension VMListCharactersPresenter: VMListCharactersPresenterToInteractor {

    public func didFetchCharacters(_ characters: [VMCharacter], toQuery query: String?) {
        defer {
            performingRequest = false
        }

        guard query == currentQuery else { return }
        allCharactersFetched = characters.count < maxOfCharactersPerPageOnFetch

        self.characters.append(contentsOf: characters)

        view.reloadCharacters()

        if self.characters.isEmpty {
            let message = VandMarvelCharacters.shared.charactersMessages.listCharactersEmptyState
            view.showEmptyState(withMessage: message, showTryAgainButton: false)
        }

        performingRequest = false
    }

    public func didFailOnFetchCharacters(with error: Error, toQuery query: String?) {
        defer {
            performingRequest = false
        }

        guard query == currentQuery else { return }

        var message: String = VandMarvelCharacters.shared.charactersMessages.alertMessage

        if let error = error as? VMError, error == .noInternet {
            message = VandMarvelCharacters.shared.charactersMessages.withoutInternetConnection
        }

        let title = VandMarvelCharacters.shared.charactersMessages.alertTitle

        view.showErrorAlert(withTitle: title, withMessage: message)
        view.showEmptyState(withMessage: message, showTryAgainButton: true)
    }

}

fileprivate extension Array where Element == VMCharacter {

    subscript(unsafeIndex unsafeIndex: Int) -> VMCharacter? {
        unsafeIndex < count  ? self[unsafeIndex] : nil
    }

}
