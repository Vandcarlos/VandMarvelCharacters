// Created on 19/01/21. Copyright © 2021 Vand. All rights reserved.

import VandMarvelUIKit
import SnapKit

protocol MainViewDelegate: AnyObject {

    func mainView(
        _ mainView: MainView,
        didSelectOption option: MainView.Option,
        dryRun: Bool
    )

}

class MainView: UIView, VMViewCode {

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: MainViewDelegate?

    enum Option: CaseIterable {

        case listCharacter
        case characterDetails
        case favoriteCharacters

        var title: String {
            switch self {
            case .listCharacter: return "List characters"
            case .characterDetails: return "Character details"
            case .favoriteCharacters: return "Favorite characters"
            }
        }

    }

    private let dryRunStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()

    private let dryRunLabel: UILabel = {
        let label = UILabel()
        label.text = "Enable dry run"
        return label
    }()

    private let dryRunSwitch = UISwitch()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OptionCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    func buildHierarchy() {
        dryRunStackView.addArrangedSubview(dryRunLabel)
        dryRunStackView.addArrangedSubview(dryRunSwitch)

        addSubview(dryRunStackView)

        addSubview(tableView)
    }

    func setupConstraints() {
        dryRunStackView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalTo(safeAreaLayoutGuide).inset(8)
        }

        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(dryRunStackView.snp.bottom)
            maker.leading.bottom.trailing.equalTo(safeAreaLayoutGuide).inset(8)
        }
    }

    func configViews() {
        backgroundColor = .white
    }

}

extension MainView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Option.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(OptionCell.self, for: indexPath)
        cell.title = Option.allCases[indexPath.row].title
        return cell
    }

}

extension MainView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.mainView(self, didSelectOption: Option.allCases[indexPath.row], dryRun: dryRunSwitch.isOn)
    }

}

extension MainView {

    class OptionCell: UITableViewCell, VMViewCode {

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupView()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        var title: String? {
            get { titleLabel.text }
            set {
                titleLabel.text = newValue
                titleLabel.accessibilityLabel = newValue
            }
        }

        private let titleLabel = UILabel()

        func buildHierarchy() {
            contentView.addSubview(titleLabel)
        }

        func setupConstraints() {
            titleLabel.snp.makeConstraints { maker in
                maker.edges.equalTo(self.contentView.safeAreaInsets)
            }
        }

        func configViews() {
            titleLabel.font = VMFont.body(size: .md).font
        }

    }

}
