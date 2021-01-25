// Created on 24/01/21. 

import VandMarvelUIKit
import SnapKit

public class VMCharacterDetailsView: UIView, VMViewCode {

    public init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let scrollView = UIScrollView()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()

    public var character: VMCharacter? {
        didSet {
            characterImageView.image = character?.image
            favoriteButton.isSelected = character?.isFavorited ?? false
            nameLabel.text = character?.name
            descLabel.text = character?.description
        }
    }

    private let characterImageView = VMCharacterImageView()

    private let favoriteButton = VMFavoriteButton()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = VMFont.title(size: .md).font
        label.textColor = VMColor.neutral.color
        label.numberOfLines = 0
        return label
    }()

    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = VMFont.body(size: .sm).font
        label.textColor = VMColor.neutral.color
        label.numberOfLines = 0
        return label
    }()

    public func buildHierarchy() {
        contentStackView.addArrangedSubview(characterImageView)
        contentStackView.addArrangedSubview(favoriteButton)
        contentStackView.addArrangedSubview(nameLabel)
        contentStackView.addArrangedSubview(descLabel)
        contentStackView.addSpace()

        scrollView.addSubview(contentStackView)

        addSubview(scrollView)
    }

    public func setupConstraints() {
        characterImageView.snp.makeConstraints { maker in
            maker.height.lessThanOrEqualTo(320)
        }

        contentStackView.snp.makeConstraints { maker in
            maker.edges.equalTo(scrollView).inset(8)
            maker.width.equalTo(safeAreaLayoutGuide).inset(8)
            maker.height.equalTo(safeAreaLayoutGuide).priority(.low)
        }

        scrollView.snp.makeConstraints { maker in
            maker.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    public func configViews() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTouchUpInsiede), for: .touchUpInside)
    }

    @objc private func favoriteButtonTouchUpInsiede() {
        character?.isFavorited = favoriteButton.isSelected
    }

}
