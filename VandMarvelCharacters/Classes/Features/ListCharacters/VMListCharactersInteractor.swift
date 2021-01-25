// Created on 21/01/21. 

import VandMarvelAPI

public protocol VMListCharactersPresenterToInteractor {

    func didFetchCharacters(_ characters: [VMCharacter], toQuery query: String?)
    func didFailOnFetchCharacters(with error: Error, toQuery query: String?)

}

public class VMListCharactersInteractor {

    public init() {}

    public var presenter: VMListCharactersPresenterToInteractor?

}

extension VMListCharactersInteractor: VMListCharactersInteractorToPresenter {

    public func fetchCharacters(withQuery query: String?, limit: Int, offset: Int) {
        VMCharactersAPIRepository.fetchCharcters(
            limit: limit,
            offset: offset,
            nameStartsWith: query
        ) { result in
            switch result {
            case .success(let characters):
                DispatchQueue.main.async { [weak self] in
                    self?.presenter?.didFetchCharacters(characters, toQuery: query)
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.presenter?.didFailOnFetchCharacters(with: error, toQuery: query)
                }
            }
        }
    }
}
