// Created on 24/01/21. 

import VandMarvelUIKit

public protocol VMCharacterDetailsPresenterToView: AnyObject {

    func viewDidLoad()

}

public class VMCharacterDetailsViewController: VMBaseViewController {

    public weak var presenter: VMCharacterDetailsPresenterToView?

    private let characterDetailsView = VMCharacterDetailsView()

    public override func loadView() {
        view = characterDetailsView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

}

extension VMCharacterDetailsViewController: VMCharacterDetailsViewToPresenter {

    public func updateContent(with character: VMCharacter) {
        characterDetailsView.character = character
    }

}
