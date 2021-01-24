//
//  ViewController.swift
//  VandMarvelCharacters
//
//  Created by Vandcarlos on 01/19/2021.
//  Copyright (c) 2021 Vandcarlos. All rights reserved.
//

import UIKit
import VandMarvelCharacters

class MainViewController: UIViewController {

    private lazy var mainView: MainView = {
        let view = MainView()
        view.delegate = self
        return view
    }()

    private lazy var router = MainViewRouter(viewController: self)

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension MainViewController: MainViewDelegate {

    func mainView(_ mainView: MainView, didSelectOption option: MainView.Option) {
        switch option {
        case .listCharacter: router.toListCharacters()
        }
    }

}
