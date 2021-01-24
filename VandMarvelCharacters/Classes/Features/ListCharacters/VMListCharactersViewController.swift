// Created on 21/01/21. 

import VandMarvelUIKit

public protocol VMListCharactersPresenterToView: AnyObject {

    var numberOfCharacters: Int { get }

    func viewDidAppear()

    func filter(withQuery query: String?)
    func cancelFilter()

    func character(atRow row: Int) -> VMCharacter?

    func tryAgainDidTap()

}

public class VMListCharactersViewController: VMSearchViewController {

    public weak var presenter: VMListCharactersPresenterToView?

    private lazy var listCharactersView: VMListCharactersView = {
        let view = VMListCharactersView()
        view.delegate = self
        return view
    }()

    public override func loadView() {
        view = listCharactersView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.delegate = self
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter?.viewDidAppear()
    }

}

extension VMListCharactersViewController: VMListCharactersViewDelegate {

    public func listCharactersViewNumberOfCharacters(_ listCharactersView: VMListCharactersView) -> Int? {
        presenter?.numberOfCharacters
    }

    public func listCharactersView(
        _ listCharactersView: VMListCharactersView,
        characterAtRow row: Int
    ) -> VMCharacter? {
        presenter?.character(atRow: row)
    }

    public func listCharactersViewTryAgainButtonDidTap(_ listCharactersView: VMListCharactersView) {
        presenter?.tryAgainDidTap()
    }

}

extension VMListCharactersViewController: UISearchBarDelegate {

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter?.filter(withQuery: searchBar.text)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.cancelFilter()
    }

}

extension VMListCharactersViewController: VMListCharactersViewToPresenter {

    public func reloadCharacters() {
        listCharactersView.reloadData()
    }

    public func showErrorAlert(withTitle title: String, withMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        let tryAgainTitle = VandMarvelCharacters.shared.charactersMessages.tryAgainAction

        let tryAgainAction = UIAlertAction(title: tryAgainTitle, style: .default) { _ in
            self.presenter?.viewDidAppear()
        }

        alert.addAction(tryAgainAction)

        let cancelTitle = VandMarvelCharacters.shared.charactersMessages.cancelAction

        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)

        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    public func showEmptyState(withMessage message: String, showTryAgainButton: Bool) {
        listCharactersView.showEmptyState(withMessage: message, showTryAgainButton: showTryAgainButton)
    }

}
