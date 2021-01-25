// Created on 24/01/21. Copyright © 2021 Vand. All rights reserved.

import XCTest
@testable import VandMarvelCharacters
import VandMarvelAPI

class ListCharactersTests: XCTestCase {

    var presenter: VMListCharactersPresenter!
    var view: ListCharactersView!
    var interactor: ListCharactersInteractor!
    var router: ListCharactersRouter!

    override func setUp() {
        super.setUp()

        view = ListCharactersView()
        interactor = ListCharactersInteractor()
        router = ListCharactersRouter()
        presenter = VMListCharactersPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testShowFakeCharactersOnAppear() {
        let expec = expectation(description: "Loaded fake characters")

        view.reloadCharactersHandler = { callNumber in
            if callNumber == 1 {
                expec.fulfill()
            }
        }

        presenter.viewWillAppear()

        waitForExpectations(timeout: 1)

        XCTAssertNotEqual(view.fakeCharactersShowing, 0, "Showing fake")
        XCTAssertTrue(view.charctersShowing.isEmpty, "Not has characters")
    }   

    func testFetchCharactersOnAppearIfNotHasCharactersLoaded() {
        let onlyFakeExpec = expectation(description: "Loaded only fake characters")
        let onlyRealExpec = expectation(description: "Loaded only real characters")

        interactor.characters = MockCharacters.generateCharacters(quantity: 4)

        view.reloadCharactersHandler = { callNumber in
            switch callNumber {
            case 1: onlyFakeExpec.fulfill()
            case 2: onlyRealExpec.fulfill()
            default: break
            }
        }

        presenter.viewWillAppear()

        waitForExpectations(timeout: 1)

        XCTAssertFalse(view.charctersShowing.isEmpty, "Showing all characters generated")
        XCTAssertEqual(view.fakeCharactersShowing, 0, "Not has fake on screen")
    }

    func testShowFirstBatchOfCharactersAndFakesToIndicateHasMore() {
        let onlyFakeExpec = expectation(description: "Loaded only fake characters")
        let firstBatchExpec = expectation(description: "Loaded first batch of real characters")

        interactor.characters = MockCharacters.generateCharacters(quantity: 14)

        view.reloadCharactersHandler = { callNumber in
            switch callNumber {
            case 1: onlyFakeExpec.fulfill()
            case 2: firstBatchExpec.fulfill()
            default: break
            }
        }

        presenter.viewWillAppear()

        waitForExpectations(timeout: 1)

        XCTAssertEqual(view.charctersShowing.count, 10, "Showing first batch of characters")
        XCTAssertNotEqual(view.fakeCharactersShowing, 0, "Showing fake characters")
    }

    func testShowAllCharactersAndHideFakeInLastBatch() {
        let onlyFakeExpec = expectation(description: "Loaded only fake characters")
        let firstBatchExpec = expectation(description: "Loaded first batch of real characters")
        let secondBatchExpec = expectation(description: "Loaded second batch of real characters")
        let thirdBatchExpec = expectation(description: "Loaded third batch of real characters")

        interactor.characters = MockCharacters.generateCharacters(quantity: 24)

        view.reloadCharactersHandler = { callNumber in
            switch callNumber {
            case 1: onlyFakeExpec.fulfill()
            case 2: firstBatchExpec.fulfill()
            case 3: secondBatchExpec.fulfill()
            case 4: thirdBatchExpec.fulfill()
            default: break
            }
        }

        presenter.viewWillAppear()

        wait(for: [onlyFakeExpec], timeout: 1)

        XCTAssertNotEqual(view.fakeCharactersShowing, 0, "Showing fake")
        XCTAssertTrue(view.charctersShowing.isEmpty, "Not has characters")


        wait(for: [firstBatchExpec], timeout: 1)

        XCTAssertNotEqual(view.fakeCharactersShowing, 0, "Showing fake")
        XCTAssertEqual(view.charctersShowing.count, 10, "Showing first batch of characters")

        wait(for: [secondBatchExpec], timeout: 1)

        XCTAssertNotEqual(view.fakeCharactersShowing, 0, "Showing fake")
        XCTAssertEqual(view.charctersShowing.count, 20, "Showing second batch of characters")

        wait(for: [thirdBatchExpec], timeout: 2)

        XCTAssertEqual(view.fakeCharactersShowing, 0, "Not showing fake")
        XCTAssertEqual(view.charctersShowing.count, 24, "Showing third batch of characters")
    }

    func testPreventDuplicateCharactersById() {
        let onlyFakeExpec = expectation(description: "Loaded only fake characters")
        let firstBatchExpec = expectation(description: "Loaded first batch of real characters")

        let characters = MockCharacters.generateCharacters(quantity: 3)

        interactor.characters = characters + characters

        view.reloadCharactersHandler = { callNumber in
            switch callNumber {
            case 1: onlyFakeExpec.fulfill()
            case 2: firstBatchExpec.fulfill()
            default: break
            }
        }

        presenter.viewWillAppear()

        waitForExpectations(timeout: 1)

        XCTAssertEqual(view.charctersShowing.count, 3, "Showing first batch of characters")
    }

    func testShowingEmptyStateCorrectly() {
        let showEmptyStateExpec = expectation(description: "Showing empty state")

        interactor.characters = []

        var showTryAgainButton = false

        view.showEmptyStateHandler = { _, showTryAgain in
            showTryAgainButton = showTryAgain
            showEmptyStateExpec.fulfill()
        }

        presenter.viewWillAppear()

        waitForExpectations(timeout: 1)

        XCTAssertTrue(view.charctersShowing.isEmpty, "Not has characters")
        XCTAssertEqual(view.fakeCharactersShowing, 0, "Not has fake characters")
        XCTAssertFalse(showTryAgainButton, "Not showing try again")
    }

    func testShowingCorrectEmptyStateMessage() {
        let showEmptyStateExpec = expectation(description: "Showing empty state")

        class VMCharactersMessages: VMCharactersMessagesDefault {

            override var listCharactersEmptyState: String { "Test empty state" }

        }

        let charactersMessages = VMCharactersMessages()

        VandMarvelCharacters.shared.charactersMessages = charactersMessages

        var emptyStateMessage: String?

        view.showEmptyStateHandler = { message , _ in
            emptyStateMessage = message
            showEmptyStateExpec.fulfill()
        }

        presenter.viewWillAppear()

        waitForExpectations(timeout: 1)

        XCTAssertEqual(charactersMessages.listCharactersEmptyState, emptyStateMessage, "Empty state is equal to setted")
    }

    func testShowAlertError() {
        let showAlertErrorExpec = expectation(description: "Showing alert error")

        interactor.forceError = VMError.generic

        var alertErrorShowed = false
        view.showErrorAlertHandler = { _, _ in
            alertErrorShowed = true
            showAlertErrorExpec.fulfill()
        }

        presenter.viewWillAppear()

        waitForExpectations(timeout: 1)

        XCTAssertTrue(alertErrorShowed)
    }

    func testShowEmptyStateError() {
        let showEmptyStateExpec = expectation(description: "Showing empty state in error")

        interactor.forceError = VMError.generic

        var showTryAgainButton = false

        view.showEmptyStateHandler = { _, showTryAgain in
            showTryAgainButton = showTryAgain
            showEmptyStateExpec.fulfill()
        }

        presenter.viewWillAppear()

        waitForExpectations(timeout: 1)

        XCTAssertTrue(view.charctersShowing.isEmpty, "Not has characters")
        XCTAssertEqual(view.fakeCharactersShowing, 0, "Not has fake characters")
        XCTAssertTrue(showTryAgainButton, "Showing try again")
    }

    func testFilterCharacters() {
        let onlyFakeExpec = expectation(description: "Loaded only fake characters")
        let allCharactersExpec = expectation(description: "Loaded all characters")
        let onlyFakeExpecAfterFilter = expectation(description: "Loaded only fake characters")
        let filterExpec = expectation(description: "Loaded only filtered characters")
        let onlyFakeExpecAfterCancelFilter = expectation(description: "Loaded only fake characters")
        let cancelFilterExpec = expectation(description: "Loaded all characters afeter cancel filter")

        let characters = MockCharacters.generateCharacters(quantity: 4, name: "jhon doe")

        interactor.characters = characters + [.init(id: 5, name: "test", description: "test test")]

        view.reloadCharactersHandler = { callNumber in
            switch callNumber {
            case 1: onlyFakeExpec.fulfill()
            case 2: allCharactersExpec.fulfill()
            case 3: onlyFakeExpecAfterFilter.fulfill()
            case 4: filterExpec.fulfill()
            case 5: onlyFakeExpecAfterCancelFilter.fulfill()
            case 6: cancelFilterExpec.fulfill()
            default: break
            }
        }

        presenter.viewWillAppear()

        wait(for: [onlyFakeExpec, allCharactersExpec], timeout: 1)

        XCTAssertEqual(view.charctersShowing.count, 5, "Showing all characters before filter")

        presenter.filter(withQuery: "tes")

        wait(for: [onlyFakeExpecAfterFilter, filterExpec], timeout: 1)

        XCTAssertEqual(view.charctersShowing.count, 1, "Showing only filtered characters")

        presenter.cancelFilter()

        wait(for: [onlyFakeExpecAfterCancelFilter, cancelFilterExpec], timeout: 1)

        XCTAssertEqual(view.charctersShowing.count, 5, "Showing all characters after cancel filter")
    }

}

import Foundation

extension ListCharactersTests {

    class ListCharactersView: VMListCharactersViewToPresenter {

        var presenter: VMListCharactersPresenterToView!

        // MARK: View controll

        var charctersShowing: [VMCharacter] = []
        var fakeCharactersShowing = 0

        var reloadCharactersHandler: ((_ callNumber: Int) -> Void)?
        var reloadCharactersHandlerNumber = 0

        var showErrorAlertHandler: ((_ title: String, _ message: String) -> Void)?
        var hasAlertShowed = false

        var showEmptyStateHandler: ((_ message: String, _ showTryAgainButton: Bool) -> Void)?
        var emptyStateIsShowed = false

        func reloadCharacters() {
            charctersShowing = []
            fakeCharactersShowing = 0
            reloadCharactersHandlerNumber += 1

            debugPrint("test", self.presenter!.numberOfCharacters, reloadCharactersHandlerNumber)

            Array(0..<self.presenter!.numberOfCharacters).forEach {
                if let character = presenter!.character(atRow: $0) {
                    self.charctersShowing.append(character)
                } else {
                    self.fakeCharactersShowing += 1
                }
            }

            reloadCharactersHandler?(reloadCharactersHandlerNumber)
        }

        func showErrorAlert(withTitle title: String, withMessage message: String) {
            guard !hasAlertShowed else { return }
            hasAlertShowed = true
            showErrorAlertHandler?(title, message)

        }

        func showEmptyState(withMessage message: String, showTryAgainButton: Bool) {
            guard !emptyStateIsShowed else { return }
            emptyStateIsShowed = true
            showEmptyStateHandler?(message, showTryAgainButton)
        }
    }

    class ListCharactersInteractor: VMListCharactersInteractorToPresenter {

        var presenter: VMListCharactersPresenterToInteractor!

        var characters: [VMCharacter] = []

        var forceError: Error?

        func fetchCharacters(withQuery query: String?, limit: Int, offset: Int) {
            DispatchQueue.main.async {
                if let error = self.forceError {
                    self.presenter.didFailOnFetchCharacters(with: error, toQuery: query)
                }

                let characters = self.filteredCharacters(to: query).dropFirst(offset).prefix(limit)


                self.presenter.didFetchCharacters(Array(characters), toQuery: query)
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

    class ListCharactersRouter: VMListCharactersRouterToPresenter {

        var characterToOpen: VMCharacter?

        func openDetails(of character: VMCharacter) {
            characterToOpen = character
        }

    }


}
