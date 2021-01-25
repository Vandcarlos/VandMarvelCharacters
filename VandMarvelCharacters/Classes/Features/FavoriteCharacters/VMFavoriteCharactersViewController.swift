// Created on 25/01/21. 

import VandMarvelUIKit

public protocol VMFavoriteCharactersPresenterToView: AnyObject {

    func viewWillAppear()

    var numberOfCharacters: Int { get }

    func filter(withQuery query: String?)
    func cancelFilter()

    func character(atRow row: Int) -> VMCharacter?
    func didSelectCharacter(atRow row: Int)
    func didUnfavoriteCharacter(atRow row: Int)

}

public class VMFavoriteCharactersViewController: VMSearchViewController {

    public weak var presenter: VMFavoriteCharactersPresenterToView?

    private lazy var favoriteCharactersView: VMFavoriteCharactersView = {
        let view = VMFavoriteCharactersView()
        view.delegate = self
        return view
    }()

    public override func loadView() {
        view = favoriteCharactersView
    }

    public override func viewDidLoad() {
        searchController.searchBar.delegate = self
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }

}

extension VMFavoriteCharactersViewController: VMFavoriteCharactersViewDelegate {

    public func favoriteCharactersViewNumberOfCharacters(_ view: VMFavoriteCharactersView) -> Int? {
        presenter?.numberOfCharacters
    }

    public func favoriteCharacters(
        _ view: VMFavoriteCharactersView,
        characterAtRow row: Int
    ) -> VMCharacter? {
        presenter?.character(atRow: row)
    }

    public func favoriteCharacters(_ view: VMFavoriteCharactersView, didSelectCharacterAtRow row: Int) {
        presenter?.didSelectCharacter(atRow: row)
    }

    public func favoriteCharacters(
        _ favoriteCharacter: VMFavoriteCharactersView,
        didUnfavoriteCharacterAtRow row: Int
    ) {
        presenter?.didUnfavoriteCharacter(atRow: row)
    }

}

extension VMFavoriteCharactersViewController: UISearchBarDelegate {

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter?.filter(withQuery: searchBar.text)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.cancelFilter()
    }

}

extension VMFavoriteCharactersViewController: VMFavoriteCharactersViewToPresenter {

    public func reloadCharacters() {
        favoriteCharactersView.reloadData()
    }

    public func showEmptyState(withMessage message: String) {
        favoriteCharactersView.showEmptyState(withMessage: message)
    }
}
