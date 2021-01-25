// Created on 25/01/21. Copyright © 2021 Vand. All rights reserved.

import XCTest
@testable import VandMarvelCharacters
import VandMarvelAPI

class FavoriteCharactersTests: XCTestCase {

    var presenter: VMFavoriteCharactersPresenter!
    var view: FavoriteCharactersView!
    var interactor: FavoriteCharactersInteractor!
    var router: FavoriteCharactersRouter!

    override func setUp() {
        super.setUp()

        view = FavoriteCharactersView()
        interactor = FavoriteCharactersInteractor()
        router = FavoriteCharactersRouter()
        presenter = VMFavoriteCharactersPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
    }

    func testFilterCharacters() {
        let allCharactersExpec = expectation(description: "Loaded all characters")
        let filterExpec = expectation(description: "Loaded only filtered characters")
        let cancelFilterExpec = expectation(description: "Loaded all characters afeter cancel filter")

        let characters = MockCharacters.generateCharacters(quantity: 4, name: "jhon doe")

        interactor.characters = characters + [.init(id: 5, name: "test", description: "test test")]

        view.reloadCharactersHandler = { callNumber in
            switch callNumber {
            case 1: allCharactersExpec.fulfill()
            case 2: filterExpec.fulfill()
            case 3: cancelFilterExpec.fulfill()
            default: break
            }
        }

        presenter.viewWillAppear()

        wait(for: [allCharactersExpec], timeout: 1)

        XCTAssertEqual(view.charctersShowing.count, 5, "Showing all characters before filter")

        presenter.filter(withQuery: "tes")

        wait(for: [filterExpec], timeout: 1)

        XCTAssertEqual(view.charctersShowing.count, 1, "Showing only filtered characters")

        presenter.cancelFilter()

        wait(for: [cancelFilterExpec], timeout: 1)

        XCTAssertEqual(view.charctersShowing.count, 5, "Showing all characters after cancel filter")
    }

    func testOpenCorrectCharacter() {
        let allCharactersExpec = expectation(description: "Loaded all characters")
        interactor.characters = MockCharacters.generateCharacters(quantity: 4)

        view.reloadCharactersHandler = { callNumber in
            switch callNumber {
            case 1: allCharactersExpec.fulfill()
            default: break
            }
        }

        presenter.viewWillAppear()

        waitForExpectations(timeout: 1)

        presenter.didSelectCharacter(atRow: 2)

        XCTAssertEqual(router.characterToOpen, interactor.characters[2])
    }

    func testUnfavoriteCorrectCharacter() {
        let allCharactersExpec = expectation(description: "Loaded all characters")

        interactor.characters = MockCharacters.generateCharacters(quantity: 10)

        view.reloadCharactersHandler = { callNumber in
            switch callNumber {
            case 1: allCharactersExpec.fulfill()
            default: break
            }
        }

        presenter.viewWillAppear()

        waitForExpectations(timeout: 1)

        let firstUnfavoritedCharacter = presenter.character(atRow: 3)

        presenter.didUnfavoriteCharacter(atRow: 3)
        XCTAssertEqual(presenter.numberOfCharacters, 9)
        XCTAssertNotEqual(presenter.character(atRow: 3), firstUnfavoritedCharacter)

        let secondUnfavoritedCharacter = presenter.character(atRow: 5)

        presenter.didUnfavoriteCharacter(atRow: 5)
        XCTAssertEqual(presenter.numberOfCharacters, 8)
        XCTAssertNotEqual(presenter.character(atRow: 5), secondUnfavoritedCharacter)
    }

}

extension FavoriteCharactersTests {

    class FavoriteCharactersView: VMFavoriteCharactersViewToPresenter {

        var presenter: VMFavoriteCharactersPresenterToView!

        // MARK: View controll

        var charctersShowing: [VMCharacter] = []

        var reloadCharactersHandler: ((_ callNumber: Int) -> Void)?
        var reloadCharactersHandlerNumber = 0

        var showEmptyStateHandler: ((_ message: String) -> Void)?
        var emptyStateIsShowed = false

        func showEmptyState(withMessage message: String) {
            guard !emptyStateIsShowed else { return }
            emptyStateIsShowed = true
            showEmptyStateHandler?(message)
        }

        func reloadCharacters() {
            reloadCharactersHandlerNumber += 1

            charctersShowing = Array(0..<self.presenter!.numberOfCharacters).map {
                presenter.character(atRow: $0)
            }

            reloadCharactersHandler?(reloadCharactersHandlerNumber)
        }
    
    }

    class FavoriteCharactersInteractor: VMFavoriteCharactersInteractorToPresenter {

        var presenter: VMFavoriteCharactersPresenterToInteractor!

        var characters: [VMCharacter] = []

        func fetchCharacters(withQuery query: String?) {
            let characters = filteredCharacters(to: query)
            DispatchQueue.main.async {
                self.presenter.didFetchCharacters(characters, toQuery: query)
            }
        }

        private func filteredCharacters(to query: String?) -> [VMCharacter] {
            if let query = query {
                return characters.filter { $0.name.starts(with: query) }
            } else {
                return characters
            }
        }

    }

    class FavoriteCharactersRouter: VMFavoriteCharactersRouterToPresenter {

        var characterToOpen: VMCharacter?

        func openDetails(of character: VMCharacter) {
            characterToOpen = character
        }

    }

}
