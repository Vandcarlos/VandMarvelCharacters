// Created on 25/01/21. 

public protocol VMFavoriteCharactersPresenterToInteractor {

    func didFetchCharacters(_ characters: [VMCharacter], toQuery query: String?)

}

public class VMFavoriteCharactersInteractor {

    public init() {}

    public var presenter: VMFavoriteCharactersPresenterToInteractor?

}

extension VMFavoriteCharactersInteractor: VMFavoriteCharactersInteractorToPresenter {

    public func fetchCharacters(withQuery query: String?) {
        VMCharactersLocalRepository.getAll(filterByName: query) { characters in
            DispatchQueue.main.async { [weak self] in
                self?.presenter?.didFetchCharacters(characters, toQuery: query)
            }
        }
    }

}
