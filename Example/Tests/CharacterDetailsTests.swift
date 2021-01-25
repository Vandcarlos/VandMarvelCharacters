// Created on 25/01/21. Copyright © 2021 Vand. All rights reserved.

import XCTest
@testable import VandMarvelCharacters
import VandMarvelAPI

class CharacterDetailsTests: XCTestCase {

    var presenter: VMCharacterDetailsPresenter!

    var view: CharacterDetailsView!
    var interactor: CharacterDetailsInteractor!
    var router: CharacterDetailsRouter!
    var character: VMCharacter!

    override func setUp() {
        super.setUp()


        view = CharacterDetailsView()
        interactor = CharacterDetailsInteractor()
        router = CharacterDetailsRouter()
        character = MockCharacters.generateCharacters(quantity: 1)[0]
        presenter = VMCharacterDetailsPresenter(
            view: view,
            interactor: interactor,
            router: router,
            character: character
        )

        view.presenter = presenter
        interactor.presenter = presenter
    }

    func testSetCorrectCharacterOnLoad() {
        presenter.viewDidLoad()

        XCTAssertEqual(character, view.currentChracter)
    }

}

extension CharacterDetailsTests {

    class CharacterDetailsView: VMCharacterDetailsViewToPresenter {

        var presenter: VMCharacterDetailsPresenterToView!

        var currentChracter: VMCharacter?

        func updateContent(with character: VMCharacter) {
            currentChracter = character
        }

    }

    class CharacterDetailsInteractor: VMCharacterDetailsInteractorToPresenter {

        var presenter: VMCharacterDetailsPresenterToInteractor!

    }

    class CharacterDetailsRouter: VMCharacterDetailsRouterToPresenter {

    }

}
