// Created on 24/01/21. Copyright © 2021 Vand. All rights reserved.

import VandMarvelCharacters

class MainViewRouter {

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    private let viewController: UIViewController

}

// MARK: List Chacaters

extension MainViewRouter {

    func toListCharacters() {
        let viewController = VMListCharactersViewController()
        let interactor = ListCharactersInteractor()
        let router = VMListCharactersRouter(viewController: viewController)
        let presenter = VMListCharactersPresenter(
            view: viewController,
            interactor: interactor,
            router: router
        )

        viewController.presenter = presenter
        interactor.presenter = presenter

        self.viewController.navigationController?.pushViewController(viewController, animated: true)
    }

    class ListCharactersInteractor: VMListCharactersInteractorToPresenter {

        var presenter: VMListCharactersPresenterToInteractor?

        func fetchCharacters(withQuery query: String?, limit: Int, offset: Int) {
            let characters = filteredCharacters(to: query).dropFirst(offset).prefix(limit)

            presenter?.didFetchCharacters(Array(characters), toQuery: query)
        }

        private func filteredCharacters(to query: String?) -> [VMCharacter] {
            if let query = query {
                return MockCharacters.characters.filter { $0.name.starts(with: query) }
            } else {
                return MockCharacters.characters
            }
        }

    }

}
