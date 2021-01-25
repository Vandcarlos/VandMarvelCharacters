// Created on 24/01/21.

public protocol VMCharacterDetailsViewToPresenter {

    func updateContent(with character: VMCharacter)

}

public protocol VMCharacterDetailsInteractorToPresenter {

}

public protocol VMCharacterDetailsRouterToPresenter {

}

public class VMCharacterDetailsPresenter {

    public init(
        view: VMCharacterDetailsViewToPresenter,
        interactor: VMCharacterDetailsInteractorToPresenter,
        router: VMCharacterDetailsRouterToPresenter,
        character: VMCharacter
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.character = character
    }

    private let character: VMCharacter

    private let view: VMCharacterDetailsViewToPresenter
    private let interactor: VMCharacterDetailsInteractorToPresenter
    private let router: VMCharacterDetailsRouterToPresenter

}

extension VMCharacterDetailsPresenter: VMCharacterDetailsPresenterToView {

    public func viewDidLoad() {
        view.updateContent(with: character)
    }

}

extension VMCharacterDetailsPresenter: VMCharacterDetailsPresenterToInteractor {

}
