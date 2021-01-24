// Created on 24/01/21. Copyright © 2021 Vand. All rights reserved.

import Fakery
import VandMarvelCharacters

final class MockCharacters {

    class func generateCharacters(quantity: Int, name: String? = nil) -> [VMCharacter] {
        let faker = Faker(locale: "en_US")
        return Array(0..<quantity).map {
            VMCharacter(id: $0, name: name ?? faker.name.name(), description: faker.lorem.sentence())
        }
    }

}
