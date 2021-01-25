// Created on 24/01/21. 

public protocol VMCharacterDetailsPresenterToInteractor {

}

public class VMCharacterDetailsInteractor {

    public var presenter: VMCharacterDetailsPresenterToInteractor?

    public init() {}

}

extension VMCharacterDetailsInteractor: VMCharacterDetailsInteractorToPresenter {

}
