// Created on 25/01/21. 

import VandMarvelUIKit
import SnapKit

public protocol VMFavoriteCharactersViewDelegate: AnyObject {

    func favoriteCharactersViewNumberOfCharacters(_ view: VMFavoriteCharactersView) -> Int?

    func favoriteCharacters(_ view: VMFavoriteCharactersView, characterAtRow row: Int) -> VMCharacter?

    func favoriteCharacters(_ view: VMFavoriteCharactersView, didSelectCharacterAtRow row: Int)
    func favoriteCharacters(_ view: VMFavoriteCharactersView, didUnfavoriteCharacterAtRow row: Int)

}

public class VMFavoriteCharactersView: UIView, VMViewCode {

    public init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public weak var delegate: VMFavoriteCharactersViewDelegate?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(VMCharacterDisplayTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = VMColor.neutral.color
        label.font = VMFont.body(size: .md).font
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    public func buildHierarchy() {
        addSubview(tableView)
        addSubview(emptyLabel)
    }

    public func setupConstraints() {
        tableView.snp.makeConstraints { maker in
            maker.edges.equalTo(safeAreaLayoutGuide)
        }

        emptyLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(safeAreaLayoutGuide)
            maker.centerY.equalTo(safeAreaLayoutGuide).offset(-24)
        }
    }

    public func configViews() {

    }

    public func reloadData() {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.emptyLabel.isHidden = true
            self.tableView.reloadData()
        }
    }

    public func showEmptyState(withMessage message: String) {
        DispatchQueue.main.async {
            self.tableView.isHidden = true
            self.emptyLabel.isHidden = false
            self.emptyLabel.text = message
        }
    }

}

extension VMFavoriteCharactersView: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.favoriteCharactersViewNumberOfCharacters(self) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(VMCharacterDisplayTableViewCell.self, for: indexPath)

        if let character = delegate?.favoriteCharacters(self, characterAtRow: indexPath.row) {
            cell.isLoading = false
            cell.name = character.name
            cell.thumbnail = character.image
        } else {
            cell.isLoading = true
        }

        return cell
    }

    public func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }
        delegate?.favoriteCharacters(self, didUnfavoriteCharacterAtRow: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

}

extension VMFavoriteCharactersView: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.favoriteCharacters(self, didSelectCharacterAtRow: indexPath.row)
    }

}
