// Created on 24/01/21. Copyright © 2021 Vand. All rights reserved.

import VandMarvelCharacters

final class MockCharacters {

    static let characters: [VMCharacter] = {
        let ironMan = VMCharacter(id: 1, name: "Iron man", description: "A rich man")
        ironMan.image = UIImage(named: "iron_man")

        let siperMan = VMCharacter(id: 2, name: "Spider man", description: "A teen")
        siperMan.image = UIImage(named: "spider_man")

        let unknowMan = VMCharacter(id: 3, name: "Unknow man", description: "Not found")

        return [ironMan, siperMan, unknowMan]
    }()

}
