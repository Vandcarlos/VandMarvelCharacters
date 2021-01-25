// Created on 25/01/21. 

import UIKit

public class VMFavoriteCharactersRouter {

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    private let navigationController: UINavigationController

}

extension VMFavoriteCharactersRouter: VMFavoriteCharactersRouterToPresenter {

    public func openDetails(of character: VMCharacter) {
        let viewController = VMCharacterDetailsViewController()
        let interactor = VMCharacterDetailsInteractor()
        let router = VMCharacterDetailsRouter()
        let presenter = VMCharacterDetailsPresenter(
            view: viewController,
            interactor: interactor,
            router: router,
            character: character
        )

        viewController.presenter = presenter
        interactor.presenter = presenter

        navigationController.pushViewController(viewController, animated: true)
    }

}
