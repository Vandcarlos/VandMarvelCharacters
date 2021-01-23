// Created on 21/01/21. 

import UIKit

public class VMListCharactersRouter {

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    private let viewController: UIViewController

}

extension VMListCharactersRouter: VMListCharactersRouterToPresenter {

}
