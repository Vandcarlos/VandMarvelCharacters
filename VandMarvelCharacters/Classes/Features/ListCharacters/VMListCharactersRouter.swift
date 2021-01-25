// Created on 21/01/21. 

import UIKit

public class VMListCharactersRouter {

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    private let navigationController: UINavigationController

}

extension VMListCharactersRouter: VMListCharactersRouterToPresenter {

    public func openDetails(of character: VMCharacter) {
        let viewController = VMCharacterDetailsViewController()
        let interactor = VMCharacterDetailsInteractor()
        let router = VMCharacterDetailsRouter()
        let presenter = VMCharacterDetailsPresenter(
            view: viewController,
            interactor: interactor,
            router: router,
            charater: character
        )

        viewController.presenter = presenter
        interactor.presenter = presenter

        navigationController.pushViewController(viewController, animated: true)
    }

}
