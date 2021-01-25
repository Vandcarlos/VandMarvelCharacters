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

    func openDetails(of character: VMCharacter)

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

    private var allCharactersFetched = false
    private var lastRowGetted = 0
    private var hasError = false
    private var viewLoaded = false

    private var currentQuery: String? {
        didSet {
            if oldValue != currentQuery {
                characters = []
                performingRequest = false
                allCharactersFetched = false
                view.reloadCharacters()
            }
        }
    }

    private var performingRequest = false {
        didSet {
            fetchMoreCharacters()
        }
    }

    public func fetchMoreCharacters() {
        guard !performingRequest else { return }
        guard !allCharactersFetched else { return }
        guard lastRowGetted >= characters.count - loadMoreCharactersWhenLeft else { return }
        guard !hasError else { return }

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
        guard viewLoaded else { return 0 }
        return allCharactersFetched ? characters.count : characters.count + numberOfFakeCharacters
    }

    public func viewWillAppear() {
        viewLoaded = true
        hasError = false
        view.reloadCharacters()
    }

    public func filter(withQuery query: String?) {
        currentQuery = query
    }

    public func cancelFilter() {
        currentQuery = nil
    }

    public func character(atRow row: Int) -> VMCharacter? {
        lastRowGetted = max(row, lastRowGetted)

        fetchMoreCharacters()

        return characters[unsafeIndex: row]
    }

    public func didSelectCharacter(atRow row: Int) {
        if let character = characters[unsafeIndex: row] {
            router.openDetails(of: character)
        } else {
            debugPrint("Selected fake character")
        }
    }

    public func tryAgainDidTap() {
        hasError = false
        view.reloadCharacters()
        fetchMoreCharacters()
    }

}

extension VMListCharactersPresenter: VMListCharactersPresenterToInteractor {

    public func didFetchCharacters(_ characters: [VMCharacter], toQuery query: String?) {
        defer {
            performingRequest = false
        }

        guard query == currentQuery else { return }
        allCharactersFetched = characters.count < maxOfCharactersPerPageOnFetch

        self.characters.append(newCharacters: characters)

        view.reloadCharacters()

        if self.characters.isEmpty {
            let message = VandMarvelCharacters.shared.charactersMessages.listCharactersEmptyState
            view.showEmptyState(withMessage: message, showTryAgainButton: false)
        }
    }

    public func didFailOnFetchCharacters(with error: Error, toQuery query: String?) {
        defer {
            performingRequest = false
        }

        guard query == currentQuery else { return }

        hasError = true

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

    mutating func append(newCharacters: [VMCharacter]) {
        let characters = newCharacters
            .reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
            .filter { !contains($0) }

        append(contentsOf: characters)
    }

}
