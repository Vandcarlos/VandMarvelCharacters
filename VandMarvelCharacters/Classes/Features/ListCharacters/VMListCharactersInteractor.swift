// Created on 21/01/21. 

import VandMarvelAPI

public protocol VMListCharactersPresenterToInteractor {

    func didFetchCharacters(_ characters: [VMCharacter])
    func didFailOnFetchCharacters(with error: Error)

}

public class VMListCharactersInteractor {

    public init() {}

    public var presenter: VMListCharactersPresenterToInteractor?

}

extension VMListCharactersInteractor: VMListCharactersInteractorToPresenter {

    public func fetchCharacters(withQuery query: String?, maxResults: Int) {
        presenter?.didFailOnFetchCharacters(with: VMError.noInternet)
    }

}
