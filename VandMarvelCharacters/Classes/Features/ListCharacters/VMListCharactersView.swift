// Created on 21/01/21. 

import VandMarvelUIKit
import SnapKit
import SkeletonView

public protocol VMListCharactersViewDelegate: AnyObject {

    func listCharactersViewNumberOfCharacters(_ view: VMListCharactersView) -> Int?
    func listCharactersViewTryAgainButtonDidTap(_ view: VMListCharactersView)
    func listCharactersView(_ view: VMListCharactersView, characterAtRow row: Int) -> VMCharacter?
    func listCharactersView(_ view: VMListCharactersView, didSelectCharacterAtRow row: Int)

}

public class VMListCharactersView: UIView, VMViewCode {

    public init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public weak var delegate: VMListCharactersViewDelegate?

    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()

        let cellWidth = (UIScreen.main.bounds.width / 5) * 2
        let cellHeight = UIScreen.main.bounds.height / 3

        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)

        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(VMCharacterDisplayCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = VMColor.background.color
        collectionView.showAnimatedGradientSkeleton()
        return collectionView
    }()

    private let emptyState: EmptyStateView = {
        let view = EmptyStateView()
        view.isHidden = true
        return view
    }()

    public func buildHierarchy() {
        addSubview(collectionView)
        addSubview(emptyState)
    }

    public func setupConstraints() {
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalTo(safeAreaLayoutGuide)
        }

        emptyState.snp.makeConstraints { maker in
            maker.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    public func configViews() {
        emptyState.tryAgainButtonAddTarget(
            self,
            action: #selector(emptyStateTryAgainButtonTouchUpInside),
            for: .touchUpInside
        )
    }

    public func reloadData() {
        emptyState.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData()
    }

    public func showEmptyState(withMessage message: String, showTryAgainButton: Bool) {
        emptyState.isHidden = false
        collectionView.isHidden = true
        emptyState.message = message
        emptyState.tryAgainButtonIsHidden = !showTryAgainButton
    }

    @objc private func emptyStateTryAgainButtonTouchUpInside() {
        delegate?.listCharactersViewTryAgainButtonDidTap(self)
    }

}

extension VMListCharactersView: UICollectionViewDataSource {

    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        delegate?.listCharactersViewNumberOfCharacters(self) ?? 0
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            VMCharacterDisplayCollectionViewCell.self,
            for: indexPath
        )

        if let character = delegate?.listCharactersView(self, characterAtRow: indexPath.row) {
            cell.isLoading = false
            cell.name = character.name
            cell.thumbnail = character.image
            cell.isFavorited = character.isFavorited
            cell.favoriteHandler = { character.isFavorited = cell.isFavorited }
        } else {
            cell.isLoading = true
        }

        return cell
    }

}

extension VMListCharactersView: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.listCharactersView(self, didSelectCharacterAtRow: indexPath.row)
    }

}

extension VMListCharactersView {

    class EmptyStateView: UIView, VMViewCode {

        init() {
            super.init(frame: .zero)
            setupView()
        }

        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        var message: String? {
            get { messageLabel.text }
            set { messageLabel.text = newValue }
        }

        var tryAgainButtonIsHidden: Bool {
            get { tryAgainButton.isHidden }
            set { tryAgainButton.isHidden = newValue }
        }

        private let contentStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .equalCentering
            return stackView
        }()

        private let messageLabel: UILabel = {
            let label = UILabel()
            label.font = VMFont.body(size: .md).font
            label.textColor = VMColor.neutral.color
            label.numberOfLines = 0
            return label
        }()

        private let tryAgainButton: UIButton = {
            let button = UIButton()
            button.setTitle(VandMarvelCharacters.shared.charactersMessages.tryAgainAction , for: .normal)
            button.setTitleColor(VMColor.secondary.color, for: .normal)
            return button
        }()

        func buildHierarchy() {
            contentStackView.addArrangedSubview(messageLabel)
            contentStackView.addArrangedSubview(tryAgainButton)
            addSubview(contentStackView)
        }

        func setupConstraints() {
            contentStackView.snp.makeConstraints { maker in
                maker.centerX.equalTo(safeAreaLayoutGuide)
                maker.centerY.equalTo(safeAreaLayoutGuide).offset(-24)
            }
        }

        func configViews() {

        }

        func tryAgainButtonAddTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
            tryAgainButton.addTarget(target, action: action, for: controlEvents)
        }
    }

}
