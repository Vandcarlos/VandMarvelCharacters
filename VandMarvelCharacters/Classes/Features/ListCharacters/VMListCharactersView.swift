// Created on 21/01/21. 

import VandMarvelUIKit
import SnapKit
import SkeletonView

public protocol VMListCharactersViewDelegate: AnyObject {

    func listCharactersViewNumberOfCharacters(_ listCharactersView: VMListCharactersView) -> Int?
    func listCharactersView(
        _ listCharactersView: VMListCharactersView,
        characterAtRow row: Int
    ) -> VMCharacter?

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
        layout.itemSize = CGSize(width: 150, height: 230)
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(VMCharacterDisplayCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = VMColor.background.color
        return collectionView
    }()

    public func buildHierarchy() {
        addSubview(collectionView)
    }

    public func setupConstraints() {
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    public func configViews() {
        collectionView.showAnimatedGradientSkeleton()
    }

    public func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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

        } else {
            cell.isLoading = true
        }

        return cell
    }

}

extension VMListCharactersView: UICollectionViewDelegate {

}
